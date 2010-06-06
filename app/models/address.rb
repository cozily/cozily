include GeoKit::Geocoders

class Address < ActiveRecord::Base
  acts_as_mappable :lat_column_name => :lat,
                   :lng_column_name => :lng

  belongs_to :neighborhood
  has_many :apartments, :dependent => :destroy

  before_validation_on_create :geocode_address, :neighborhood_search
  before_validation_on_update :geocode_address, :neighborhood_search

  validates_presence_of :street,
                        :city,
                        :state,
                        :zip

  private
  def geocode_address
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
    response = JSON.parse(Yelp.new.neighborhood_for_lat_and_lng(lat, lng))
    if response.has_key?("neighborhoods") && response["neighborhoods"].present?
      response = response["neighborhoods"][0]
      neighborhood = Neighborhood.find_or_initialize_by_name_and_city(response["name"], response["city"])
      neighborhood.borough = response["borough"]
      neighborhood.state = response["state"]
      neighborhood.country = response["country"]
      neighborhood.save if neighborhood.changed?
    else
      neighborhood = nil
    end
    self.neighborhood = neighborhood
  end
end
