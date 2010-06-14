include ActionController::UrlWriter
default_url_options[:host] = "cozi.ly"

class Apartment < ActiveRecord::Base
  belongs_to :address
  belongs_to :contact
  belongs_to :user

  has_many :apartment_features, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :features, :through => :apartment_features

  has_friendly_id :name, :use_slug => true

  validates_presence_of :address, :user
  validates_numericality_of :rent, :allow_nil => true, :greater_than => 0, :only_integer => true
  validates_numericality_of :square_footage, :allow_nil => true, :greater_than => 0, :only_integer => true
  validates_numericality_of :bedrooms, :allow_nil => true
  validates_numericality_of :bathrooms, :allow_nil => true

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :contact, :reject_if => Proc.new { |attributes| attributes["name"].blank? }

  delegate :full_address, :neighborhood, :to => :address

  default_scope :order => "apartments.created_at"

  before_save :format_unit

  state_machine :state, :initial => :unpublished do
    after_transition :on => :publish do |apt|
      if RAILS_ENV == "production"
        oauth = Twitter::OAuth.new('voDmOvIReD71vENQJRR1g', 'SnK9IbDfrXxz862ImcIOmjqvfrleWRrWN1Km0vrGyds')
        oauth.authorize_from_access('154155384-9Vaj2QiXa998sIVn8XicaSVrQOM1rzvkRfAcYjHf', 'yicMo06MlgUMHSGgC5Q6lk0EicPqUZiNRrt4')
        client = Twitter::Base.new(oauth)
        client.update("#{apt.bedrooms} bedroom apt in #{apt.neighborhood.name} for $#{apt.rent} #{apartment_url(apt)}")
      end
    end

    event :publish do
      transition :unpublished => :published, :if => :publishable?
    end

    event :unpublish do
      transition :published => :unpublished
    end
  end

  def name
    [full_address, unit].reject { |str| str.blank? }.join(" #")
  end

  def publishable?
    [:address,
     :contact,
     :user,
     :rent,
     :bedrooms,
     :bathrooms,
     :square_footage].all? { |attr| self.send(attr).present? }
  end

  private
  def format_unit
    return unless self.unit
    self.unit = self.unit.delete("#").upcase
  end
end
