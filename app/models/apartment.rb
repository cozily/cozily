include Rails.application.routes.url_helpers
default_url_options[:host] = "cozi.ly"

class Apartment < ActiveRecord::Base
  REQUIRED_FIELDS = [:address, :user, :rent, :bedrooms, :bathrooms, :start_date]
  BEDROOM_CHOICES = [["0 Bedrooms (Studio)", 0], ["1 Bedroom", 1], ["2 Bedrooms", 2], ["3 Bedrooms", 3], ["4+ Bedrooms", 4]]

  include Eventable

  paginates_per 10

  belongs_to :address
  belongs_to :user

  has_many :apartment_features, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :features, :through => :apartment_features
  has_many :flags, :dependent => :destroy
  has_many :photos, :order => "position", :dependent => :destroy
  has_many :conversations, :dependent => :destroy, :order => "created_at desc"

  acts_as_mappable :through => :address
  has_friendly_id :name, :use_slug => true, :allow_nil => true

  delegate :full_address, :lat, :lng, :street, :to => :address

  before_validation :format_unit
  after_create :email_owner
  # after_commit :resque_solr_update
  # before_destroy :resque_solr_remove

  state_machine :state, :initial => :unpublished do
    after_transition :on => :unpublish do |apt|
      TimelineEvent.create(:event_type => "state_changed_to_unpublished",
                           :subject => apt,
                           :actor => apt.user)
    end

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
      TimelineEvent.create(:event_type => "state_changed_to_published",
                           :subject => apt,
                           :actor => apt.user)
      Resque.enqueue(MatchNotifierJob, apt.id) unless defined?(Rake)
    end

    state :published do
      validates_presence_of :address, :user, :start_date
      validates_presence_of :end_date, :if => Proc.new { |apartment| apartment.sublet? }
      validates_length_of :unit, :maximum => 5
      validates_numericality_of :rent, :greater_than => 500, :less_than => 50_000, :only_integer => true
      validates_numericality_of :square_footage, :allow_nil => true, :greater_than => 0, :less_than_or_equal_to => 10_000, :only_integer => true
      validates_numericality_of :bedrooms, :greater_than_or_equal_to => 0
      validates_numericality_of :bathrooms, :greater_than_or_equal_to => 0
      validates_uniqueness_of :address_id, :scope => [ :user_id, :unit ], :unless => :imported?
    end

    state :unpublished do
      validates_presence_of :user
      validates_presence_of :end_date, :if => Proc.new { |apartment| apartment.sublet? }
      validates_length_of :unit, :maximum => 5
      validates_numericality_of :rent, :allow_nil => true, :greater_than => 500, :less_than => 50_000, :only_integer => true
      validates_numericality_of :square_footage, :allow_nil => true, :greater_than => 0, :less_than => 10_000, :only_integer => true
      validates_numericality_of :bedrooms, :greater_than_or_equal_to => 0, :allow_nil => true
      validates_numericality_of :bathrooms, :greater_than_or_equal_to => 0, :allow_nil => true
      validates_uniqueness_of :address_id, :scope => [ :user_id, :unit ], :allow_nil => true, :unless => :imported?
    end

    event :publish do
      transition :unpublished => :published, :if => :publishable?
    end

    event :unpublish do
      transition :published => :unpublished
    end

    event :flag do
      transition [:unpublished, :published] => :flagged
    end
  end

  scope :bedrooms_near, lambda { |count| where("bedrooms >= ? and bedrooms <= ?", count - 0.5, count + 0.5) }
  scope :rent_near, lambda { |amount| where("rent >= ? and rent <= ?", amount * 0.8, amount * 1.2) }


  def published
    state == "published"
  end

  searchable do
    text :unit
    text :state
    time :published_at
    integer :rent
    integer :square_footage
    double :bedrooms
    double :bathrooms
    date :start_date
    date :end_date
    boolean :sublet
    boolean :imported
    boolean :published

    integer :neighborhood_ids, :multiple => true
    integer :feature_ids, :multiple => true
  end

  class << self
    def distinct_bedrooms
      where(:state => "published").select('DISTINCT bedrooms').map(&:bedrooms).sort
    end

    def unpublish_stale_apartments
      apts = Apartment.all(:conditions => ["state = 'published' AND (end_date < ? OR published_at < ?)", Date.today, 3.weeks.ago])
      apts.each do |apartment|
        apartment.unpublish!
        ApartmentMailer.unpublished_stale_apartment_notification(apartment.id).deliver
      end
    end
  end

  def neighborhoods
    Neighborhood.joins(:addresses => :apartments).where("apartments.id" => self.id)
  end

  def neighborhood_ids
    neighborhoods.map(&:id)
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

  def full_address
    address.try(:full_address)
  end

  def full_address=(full_address)
    unless full_address == self.address.try(:full_address)
      self.address = Address.for_full_address(full_address)
    end
  end

  def name
    [full_address, unit].reject { |str| str.blank? }.join(" #") if address && address.valid?
  end

  def quick_name
    [full_address, unit].reject { |str| str.blank? }.join(" #") if address && address.geocoded?
  end

  def address_name
    full_address.split(",").first if address && address.geocoded?
  end

  def nearby_stations
    return [] unless address
    nearest_stations = Station.find(:all, :origin => [lat, lng], :within => 0.5, :order => 'distance')
    if nearest_stations.empty?
      Station.find(:all, :origin => [lat, lng], :order => 'distance', :limit => 1)
    else
      unique_stations = nearest_stations.uniq {|a| [a.name, a.train_group]}.map {|a| [a.name, a.train_group]}
      [].tap do |stations|
        unique_stations.each do |unique_station|
          stations << nearest_stations[nearest_stations.index {|s| s.name == unique_station.first && s.train_group == unique_station.last}]
        end
      end
    end
  end

  def last_state_change
    subject_timeline_events.where("event_type LIKE '%state_changed%'").first
  end

  def owned_by?(user)
    self.user == user
  end

  def publishable?
    REQUIRED_FIELDS.all? { |attr| self.send(attr).present? } && valid_sublet? && valid_user?
  end

  def match_for?(user)
    return false unless user.profile

    ( user.profile.bedrooms.blank? || bedrooms >= user.profile.bedrooms ) &&
            ( user.profile.rent.blank? || rent <= user.profile.rent ) &&
            ( user.profile.neighborhoods.empty? || (neighborhoods.merge user.profile.neighborhoods).present? )
  end

  def valid_sublet?
    !sublet || (start_date.present? && end_date.present?)
  end

  def valid_user?
    user && user.phone.present? && user.email_confirmed?
  end

  protected
  def resque_solr_update
    Resque.enqueue(SolrUpdate, Apartment, id)
  end

  def resque_solr_remove
    Resque.enqueue(SolrRemove, Apartment, id)
  end

  private
  def email_owner
    unless user.has_received_first_apartment_notification?
      UserMailer.first_apartment_notification(user.id).deliver
      FirstApartmentNotification.create(:user => user)
    end
  end

  def format_unit
    return unless self.unit
    self.unit = self.unit.delete("#-").upcase.strip
  end
end
