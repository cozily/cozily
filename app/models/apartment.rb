include Rails.application.routes.url_helpers
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

  before_validation :format_unit
  after_create :email_owner

  [:unpublished, :published, :leased].each do |state|
    fires :"state_changed_to_#{state}",
          :on => :update,
          :actor => :user,
          :if => lambda { |apartment| apartment.state_changed? && apartment.state_name == state }
  end

  state_machine :state, :initial => :unpublished do
    after_transition :on => :publish do |apt|
      component(:tweet_apartments) do
        client = TwitterOAuth::Client.new(
                :consumer_key => 'voDmOvIReD71vENQJRR1g',
                :consumer_secret => 'SnK9IbDfrXxz862ImcIOmjqvfrleWRrWN1Km0vrGyds',
                :token => '154155384-9Vaj2QiXa998sIVn8XicaSVrQOM1rzvkRfAcYjHf',
                :secret => 'yicMo06MlgUMHSGgC5Q6lk0EicPqUZiNRrt4'
        )
        client.update("#{apt.user.first_name} just published a #{apt.bedrooms.prettify} bedroom apt in #{apt.neighborhood.name} for $#{apt.rent} #{apartment_url(apt)}")
      end
      apt.update_attribute(:published_at, Time.now)
      Delayed::Job.enqueue(MatchNotifierJob.new(apt))
    end

    state :published do
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

    state :unpublished do
      validates_presence_of :user
      validates_presence_of :end_date, :if => Proc.new { |apartment| apartment.sublet? }
      validates_numericality_of :rent, :allow_nil => true, :greater_than => 0, :only_integer => true
      validates_numericality_of :square_footage, :allow_nil => true, :greater_than => 0, :only_integer => true
      validates_numericality_of :bedrooms, :greater_than_or_equal_to => 0, :allow_nil => true
      validates_numericality_of :bathrooms, :greater_than_or_equal_to => 0, :allow_nil => true
      validates_uniqueness_of :address_id, :scope => [ :user_id, :unit ], :allow_nil => true
    end

    event :publish do
      transition [:unpublished, :leased] => :published, :if => :publishable?
    end

    event :unpublish do
      transition [:published, :leased] => :unpublished
    end

    event :lease do
      transition [:published, :unpublished] => :leased, :if => :publishable?
    end
  end

  scope :bedrooms_near, lambda { |count| where("bedrooms >= ? and bedrooms <= ?", count - 0.5, count + 0.5) }
  scope :rent_near, lambda { |amount| where("rent >= ? and rent <= ?", amount * 0.8, amount * 1.2) }

  class << self
    def per_page
      10
    end

    def unpublish_stale_apartments
      apts = Apartment.all(:conditions => ["state = 'published' AND (end_date < ? OR published_at < ?)", Date.today, 3.weeks.ago])
      apts.each do |apartment|
        apartment.unpublish!
        ApartmentMailer.send_later(:deliver_unpublished_stale_apartment_notification, apartment)
      end
    end
  end

  def as_json(options = {})
    super(options)
  end

  def comparable_apartments
    return [] unless bedrooms && rent && address
    Apartment.with_state(:published).bedrooms_near(bedrooms).rent_near(rent).to_a.sort_by_distance_from(self) - [self]
  end

  def missing_associations
    missing_associations = []
    missing_associations << :images unless images.count > 1
    missing_associations << :phone unless user && user.phone.present?
    missing_associations << :email_confirmed unless user && user.email_confirmed?
    missing_associations
  end

  def missing_fields
    missing_fields = []
    REQUIRED_FIELDS.each do |attr|
      missing_fields << attr unless self.send(attr).present?
    end

    missing_fields << :end_date if self.sublet? && self.end_date.blank?
    missing_fields
  end

  def full_address=(address)
    self.address = Address.for_full_address(address)
  end

  def name
    [full_address, unit].reject { |str| str.blank? }.join(" #") if address && address.valid?
  end

  def quick_name
    [full_address, unit].reject { |str| str.blank? }.join(" #") if address && address.geocoded?
  end

  def nearby_stations
    return [] unless address
    nearest_stations = Station.find(:all, :origin => [lat, lng], :within => 0.5, :order => 'distance')
    station_names = nearest_stations.map(&:name).uniq
    [].tap do |stations|
      station_names.each do |station_name|
        stations << nearest_stations.select { |s| s.name == station_name }.max{ |a, b| a.distance <=> b.distance }
      end
    end.sort { |a, b| a.distance <=> b.distance }
  end

  def last_state_change
    subject_timeline_events.where("event_type LIKE '%state_changed%'").first
  end

  def owned_by?(user)
    self.user == user
  end

  def publishable?
    REQUIRED_FIELDS.all? { |attr| self.send(attr).present? } && (images.count > 1) && valid_sublet? && valid_user?
  end

  def match_for?(user)
    return false unless user.profile

    ( user.profile.bedrooms.blank? || bedrooms >= user.profile.bedrooms ) &&
            ( user.profile.rent.blank? || rent <= user.profile.rent ) &&
            ( user.profile.neighborhoods.empty? || (neighborhoods & user.profile.neighborhoods).present? )
  end

  def valid_sublet?
    !sublet || (start_date.present? && end_date.present?)
  end

  def valid_user?
    user && user.phone.present? && user.email_confirmed?
  end

  private
  def email_owner
    unless user.has_received_first_apartment_notification?
      UserMailer.send_later(:deliver_first_apartment_notification, user)
      FirstApartmentNotification.create(:user => user)
    end
  end

  def format_unit
    return unless self.unit
    self.unit = self.unit.delete("#").upcase
  end
end
