include ActionController::UrlWriter
default_url_options[:host] = "cozi.ly"

class Apartment < ActiveRecord::Base
  REQUIRED_FIELDS = [:address, :user, :rent, :bedrooms, :bathrooms, :square_footage, :start_date]

  include Eventable

  belongs_to :address
  belongs_to :user

  has_many :apartment_features, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :features, :through => :apartment_features
  has_many :flags, :dependent => :destroy
  has_many :images, :order => "position", :dependent => :destroy
  has_many :conversations, :dependent => :destroy, :order => "created_at desc"
  has_many :neighborhoods, :finder_sql => 'select n.* from neighborhoods n
                                            inner join address_neighborhoods a1 on a1.neighborhood_id = n.id
                                             inner join addresses a2 on a2.id = a1.address_id
                                              where a2.id = #{address_id}'

  acts_as_mappable :through => :address
  has_friendly_id :name, :use_slug => true, :allow_nil => true

  delegate :full_address, :lat, :lng, :street, :to => :address

  default_scope :order => "apartments.created_at"

  before_validation :format_unit

  [:unlisted, :listed, :leased].each do |state|
    fires :"state_changed_to_#{state}",
          :on => :update,
          :actor => :user,
          :if => lambda { |apartment| apartment.state_changed? && apartment.state_name == state }
  end

  state_machine :state, :initial => :unlisted do
    after_transition :on => :list do |apt|
      component(:tweet_apartments) do
        client = TwitterOAuth::Client.new(
          :consumer_key => 'voDmOvIReD71vENQJRR1g',
          :consumer_secret => 'SnK9IbDfrXxz862ImcIOmjqvfrleWRrWN1Km0vrGyds',
          :token => '154155384-9Vaj2QiXa998sIVn8XicaSVrQOM1rzvkRfAcYjHf',
          :secret => 'yicMo06MlgUMHSGgC5Q6lk0EicPqUZiNRrt4'
        )
        client.update("#{apt.user.first_name} just listed a #{apt.bedrooms.prettify} bedroom apt in #{apt.neighborhood.name} for $#{apt.rent} #{apartment_url(apt)}")
      end
    end

    state :listed do
      validates_presence_of :address, :user, :start_date
      validates_presence_of :end_date, :if => Proc.new { |apartment| apartment.sublet? }
      validates_numericality_of :rent, :greater_than => 0, :only_integer => true
      validates_numericality_of :square_footage, :greater_than => 0, :only_integer => true
      validates_numericality_of :bedrooms, :greater_than_or_equal_to => 0
      validates_numericality_of :bathrooms, :greater_than_or_equal_to => 0
      validates_uniqueness_of :address_id, :scope => [ :user_id, :unit ]
    end

    state :leased do
      validates_presence_of :address, :user, :start_date
      validates_presence_of :end_date, :if => Proc.new { |apartment| apartment.sublet? }
      validates_numericality_of :rent, :greater_than => 0, :only_integer => true
      validates_numericality_of :square_footage, :greater_than => 0, :only_integer => true
      validates_numericality_of :bedrooms, :greater_than_or_equal_to => 0
      validates_numericality_of :bathrooms, :greater_than_or_equal_to => 0
      validates_uniqueness_of :address_id, :scope => [ :user_id, :unit ]
    end

    state :unlisted do
      validates_presence_of :user
      validates_presence_of :end_date, :if => Proc.new { |apartment| apartment.sublet? }
      validates_numericality_of :rent, :allow_nil => true, :greater_than => 0, :only_integer => true
      validates_numericality_of :square_footage, :allow_nil => true, :greater_than => 0, :only_integer => true
      validates_numericality_of :bedrooms, :greater_than_or_equal_to => 0, :allow_nil => true
      validates_numericality_of :bathrooms, :greater_than_or_equal_to => 0, :allow_nil => true
      validates_uniqueness_of :address_id, :scope => [ :user_id, :unit ], :allow_nil => true
    end

    event :list do
      transition [:unlisted, :leased] => :listed, :if => :listable?
    end

    event :unlist do
      transition [:listed, :leased] => :unlisted
    end

    event :lease do
      transition [:listed, :unlisted] => :leased, :if => :listable?
    end
  end

  named_scope :bedrooms_near, lambda { |count| { :conditions => ["bedrooms >= ? and bedrooms <= ?", count - 0.5, count + 0.5] } }
  named_scope :rent_near, lambda { |amount| { :conditions => ["rent >= ? and rent <= ?", amount * 0.8, amount * 1.2] } }

  class << self
    def per_page
      10
    end
  end

  def as_json(options = {})
    super(options)
  end

  def comparable_apartments
    return [] unless bedrooms && rent && address
    Apartment.with_state(:listed).bedrooms_near(bedrooms).rent_near(rent).to_a.sort_by_distance_from(self) - [self]
  end

  def fields_remaining_for_listing
    [].tap do |fields|
      REQUIRED_FIELDS.each { |attr| fields << attr.to_s.humanize.downcase unless self.send(attr).present? }
    end
  end

  def full_address=(address)
    self.address = Address.for_full_address(address)
  end

  def name
    [full_address, unit].reject { |str| str.blank? }.join(" #") if address
  end

  def nearby_stations
    return [] unless address
    nearest_stations = Station.find(:all, :origin => [lat, lng], :within => 0.4, :order => 'distance')
    station_names =  nearest_stations.map(&:name).uniq
    [].tap do |stations|
      station_names.each do |station_name|
        stations << nearest_stations.select { |s| s.name == station_name }.max{ |a,b| a.distance <=> b.distance }
      end
    end.sort { |a,b| a.distance <=> b.distance }
  end

  def listable?
    REQUIRED_FIELDS.all? { |attr| self.send(attr).present? } && (images_count > 1) && valid_sublet? && valid_user?
  end

  def listed_on
    subject_timeline_events.event_type_equals("state_changed_to_listed").first.try(:created_at)
  end

  def valid_sublet?
    !sublet || (start_date.present? && end_date.present?)
  end

  def valid_user?
    user && user.phone.present?
  end

  private
  def format_unit
    return unless self.unit
    self.unit = self.unit.delete("#").upcase
  end
end
