include ActionController::UrlWriter
default_url_options[:host] = "cozi.ly"

class Apartment < ActiveRecord::Base
  belongs_to :address
  belongs_to :user

  has_many :apartment_features, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :features, :through => :apartment_features

  has_friendly_id :full_address, :use_slug => true

  validates_presence_of :address,
                        :user,
                        :rent,
                        :bedrooms,
                        :bathrooms,
                        :square_footage

  accepts_nested_attributes_for :address

  delegate :full_address, :neighborhood, :to => :address

  default_scope :order => "apartments.created_at"

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
      transition :unpublished => :published
    end

    event :unpublish do
      transition :published => :unpublished
    end
  end
end
