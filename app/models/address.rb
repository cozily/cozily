include GeoKit::Geocoders

class Address < ActiveRecord::Base
  acts_as_mappable

  belongs_to :neighborhood
  has_many :apartments, :dependent => :destroy

  before_validation_on_create :geocode, :neighborhood_search
  before_validation_on_update :geocode, :neighborhood_search

  validates_presence_of :street,
                        :city,
                        :state,
                        :zip

  private
  def geocode
    return unless full_address

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
