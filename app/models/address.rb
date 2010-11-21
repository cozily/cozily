include GeoKit::Geocoders

class Address < ActiveRecord::Base
  acts_as_mappable

  has_many :address_neighborhoods, :dependent => :destroy
  has_many :apartments, :dependent => :destroy
  has_many :neighborhoods, :through => :address_neighborhoods

  before_validation :geocode, :neighborhood_search

  validates_presence_of :full_address,
                        :street,
                        :city,
                        :state,
                        :zip,
                        :lat,
                        :lng

  validates_uniqueness_of :lat, :scope => :lng
  validate :ensure_at_least_one_neighborhood

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
    self.neighborhoods = Neighborhood.for_lat_and_lng(lat, lng)
  end

  def ensure_at_least_one_neighborhood
    unless neighborhoods.present?
      errors.add(:base, "We're currently only accepting apartment listings in New York City.")
    end
  end
end
