include GeoKit::Geocoders

class Address < ActiveRecord::Base
  acts_as_mappable

  belongs_to :neighborhood
  has_many :apartments, :dependent => :destroy

  before_validation_on_create :geocode, :neighborhood_search
  before_validation_on_update :geocode, :neighborhood_search

  validates_presence_of :full_address,
                        :street,
                        :city,
                        :state,
                        :zip,
                        :lat,
                        :lng

  validates_uniqueness_of :lat, :scope => :lng

  class << self
    def for_full_address(address)
      return unless address
      location = GoogleGeocoder.geocode(address)
      if location.full_address.present?
        address = Address.find_or_initialize_by_lat_and_lng(location.lat, location.lng)
        address.full_address = location.full_address
        address.street = location.street_address
        address.city = location.city
        address.state = location.state
        address.zip = location.zip
        address.save if address.changed?
        address
      end
    end
  end

  def geocoded?
    lat.present? && lng.present?
  end

  private
  def geocode
    return if geocoded? || full_address.nil?
    location = GoogleGeocoder.geocode(full_address)
    if location.full_address.present?
      self.full_address = location.full_address
      self.street = location.street_address
      self.city = location.city
      self.state = location.state
      self.zip = location.zip
      self.lat = location.lat
      self.lng = location.lng
    end
  end

  def neighborhood_search
    self.neighborhood = Neighborhood.for_lat_and_lng(lat, lng)
  end
end
