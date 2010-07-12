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
  has_many :messages, :dependent => :destroy, :order => "created_at desc"
  has_many :neighborhoods, :finder_sql => 'select n.* from neighborhoods n
                                            inner join address_neighborhoods a1 on a1.neighborhood_id = n.id
                                             inner join addresses a2 on a2.id = a1.address_id
                                              where a2.id = #{address_id}'

  has_friendly_id :name, :use_slug => true, :allow_nil => true

  delegate :full_address, :lat, :lng, :street, :to => :address

  default_scope :order => "apartments.created_at"

  before_validation :format_unit

  [:unlisted, :listed, :leased].each do |state|
    fires :"state_changed_to_#{state}",
          :on => :update,
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
      validates_numericality_of :bedrooms
      validates_numericality_of :bathrooms
      validates_uniqueness_of :address_id, :scope => [ :user_id, :unit ]
    end

    state :unlisted do
      validates_presence_of :user
      validates_presence_of :end_date, :if => Proc.new { |apartment| apartment.sublet? }
      validates_numericality_of :rent, :allow_nil => true, :greater_than => 0, :only_integer => true
      validates_numericality_of :square_footage, :allow_nil => true, :greater_than => 0, :only_integer => true
      validates_numericality_of :bedrooms, :allow_nil => true
      validates_numericality_of :bathrooms, :allow_nil => true
      validates_uniqueness_of :address_id, :scope => [ :user_id, :unit ], :allow_nil => true
    end

    event :list do
      transition [:unlisted, :leased] => :listed, :if => :listable?
    end

    event :unlist do
      transition :listed => :unlisted
    end

    event :lease do
      transition :listed => :leased
    end
  end

  def comparable_apartments
    Apartment.with_state(:listed)
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
    Station.find(:all, :origin => [lat, lng], :within => 0.4, :order => 'distance')
  end

  def listable?
    REQUIRED_FIELDS.all? { |attr| self.send(attr).present? }
  end

  def as_json(options = {})
    super(options)
  end

  private
  def format_unit
    return unless self.unit
    self.unit = self.unit.delete("#").upcase
  end
end
