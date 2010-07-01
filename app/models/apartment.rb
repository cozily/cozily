include ActionController::UrlWriter
default_url_options[:host] = "cozi.ly"

class Apartment < ActiveRecord::Base
  REQUIRED_FIELDS = [:address, :contact, :user, :rent, :bedrooms, :bathrooms, :square_footage, :start_date]

  belongs_to :address
  belongs_to :contact
  belongs_to :user

  has_many :apartment_features, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :features, :through => :apartment_features
  has_many :images, :dependent => :destroy
  has_many :messages, :dependent => :destroy, :order => "created_at desc"

  has_friendly_id :name, :use_slug => true, :allow_nil => true

  validate :ensure_uniqueness_of_name_for_user

  accepts_nested_attributes_for :contact, :reject_if => Proc.new { |attributes| attributes["name"].blank? }

  delegate :full_address, :lat, :lng, :neighborhood, :to => :address

  default_scope :order => "apartments.created_at"

  before_save :format_unit

  state_machine :state, :initial => :unpublished do
    after_transition :on => :publish do |apt|
      component(:tweet_apartments) do
        client = TwitterOAuth::Client.new(
          :consumer_key => 'voDmOvIReD71vENQJRR1g',
          :consumer_secret => 'SnK9IbDfrXxz862ImcIOmjqvfrleWRrWN1Km0vrGyds',
          :token => '154155384-9Vaj2QiXa998sIVn8XicaSVrQOM1rzvkRfAcYjHf',
          :secret => 'yicMo06MlgUMHSGgC5Q6lk0EicPqUZiNRrt4'
        )
        client.update("#{apt.user.first_name} just published a #{apt.bedrooms.prettify} bedroom apt in #{apt.neighborhood.name} for $#{apt.rent.prettify} #{apartment_url(apt)}")
      end
    end

    state :published do
      validates_presence_of :address, :contact, :user, :start_date
      validates_numericality_of :rent, :greater_than => 0, :only_integer => true
      validates_numericality_of :square_footage, :greater_than => 0, :only_integer => true
      validates_numericality_of :bedrooms
      validates_numericality_of :bathrooms
    end

    state :unpublished do
      validates_presence_of :user
      validates_numericality_of :rent, :allow_nil => true, :greater_than => 0, :only_integer => true
      validates_numericality_of :square_footage, :allow_nil => true, :greater_than => 0, :only_integer => true
      validates_numericality_of :bedrooms, :allow_nil => true
      validates_numericality_of :bathrooms, :allow_nil => true
    end

    event :publish do
      transition :unpublished => :published, :if => :publishable?
    end

    event :unpublish do
      transition :published => :unpublished
    end
  end

  def fields_remaining_for_publishing
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

  def publishable?
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

  def ensure_uniqueness_of_name_for_user
    return unless user && address
    address.valid?
    if (user.apartments(true) - [self]).any? { |a| a.name == self.name }
      errors.add_to_base("You already have an apartment for this address and unit.")
    end
  end
end
