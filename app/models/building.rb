include GeoKit::Geocoders

class Building < ActiveRecord::Base
  ZIP_CODES = []
  acts_as_mappable

  has_many :building_neighborhoods, :dependent => :destroy
  has_many :apartments, :dependent => :destroy
  has_many :neighborhoods, :through => :building_neighborhoods

  before_validation :geocode, :neighborhood_search

  validates_presence_of :full_address,
                        :street,
                        :city,
                        :state,
                        :zip,
                        :lat,
                        :lng,
                        :accuracy

  validates_uniqueness_of :lat, :scope => :lng
  validate :ensure_at_least_one_neighborhood

  has_friendly_id :full_address, :use_slug => true, :allow_nil => true

  class << self
    def for_full_address(address_string)
      return unless address_string
      location = GoogleGeocoder.geocode(address_string)
      if location.full_address.present? && location.accuracy == 8
        building              = Building.find_or_initialize_by_lat_and_lng(location.lat, location.lng)
        building.full_address = location.full_address
        building.street       = location.street_address
        building.city         = "New York"
        building.state        = location.state
        building.zip          = location.zip
        building.accuracy     = location.accuracy
        building.save if building.changed?
        building
      end
    end
  end

  def geocoded?
    lat.present? && lng.present?
  end

  def nearby_stations
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

  private
  def geocode
    return if geocoded? || full_address.nil?
    location = GoogleGeocoder.geocode(full_address)
    if location.full_address.present?
      self.full_address = location.full_address
      self.street       = location.street_address
      self.city         = "New York"
      self.state        = location.state
      self.zip          = location.zip
      self.lat          = location.lat
      self.lng          = location.lng
      self.accuracy     = location.accuracy
    end
  end

  def neighborhood_search
    self.neighborhoods = Neighborhood.for_lat_and_lng(lat, lng)
  end

  def ensure_at_least_one_neighborhood
    unless neighborhoods.present? || ZIP_CODES.include?(self.zip)
      errors.add(:base, "We're currently only accepting apartment listings in New York City.")
    end
  end
end
