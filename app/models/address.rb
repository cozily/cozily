include GeoKit::Geocoders

class Address < ActiveRecord::Base
  acts_as_mappable :lat_column_name => :lat,
                   :lng_column_name => :lng

  before_validation_on_create :geocode_address
  before_validation_on_update :geocode_address

  validates_presence_of :street,
                        :city,
                        :state,
                        :zip

  private
  def geocode_address
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
end
