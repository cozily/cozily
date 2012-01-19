include GeoKit::Geocoders

class Address < ActiveRecord::Base
  ZIP_CODES = ["11201","11203","11204","11205","11206","11207","11208","11209","11210","11211","11212","11213","11214","11215","11216","11217","11218","11219","11220","11221","11222","11223","11224","11225","11226","11228","11229","11230","11231","11232","11233","11234","11235","11236","11237","11238","11239","10001","10002","10003","10004","10005","10006","10007","10009","10010","10011","10012","10013","10014","10016","10017","10018","10019","10020","10021","10022","10023","10024","10025","10026","10027","10028","10029","10030","10031","10032","10033","10034","10035","10036","10037","10038","10039","10040","10041","10044","10048","10069","10103","10111","10112","10115","10119","10128","10152","10153","10154","10162","10165","10167","10169","10170","10171","10172","10173","10177","10271","10278","10279","10280","10282","10043","10045","10065","10075","10080","10105","10106","10107","10110","10120","10123","10155","10158","10168","10174","10175","10176","10199","10265","10270","10311","10550","10704","10705","10803","11001","11003","11005","11020","11021","11040","11042","11096","11109","11243","11252","11359","11381","11405","11425","11439","11451","11559","11580","11581","11004","11101","11102","11103","11104","11105","11106","11354","11355","11356","11357","11358","11360","11361","11362","11363","11364","11365","11366","11367","11368","11369","11371","11372","11373","11374","11375","11377","11378","11379","11385","11411","11412","11413","11414","11415","11416","11417","11418","11419","11420","11421","11422","11423","11426","11427","11428","11429","11430","11432","11433","11434","11435","11436","11691","11692","11693","11694","11697","10301","10302","10303","10304","10305","10306","10307","10308","10309","10310","10312","10314","10451","10452","10453","10454","10455","10456","10457","10458","10459","10460","10461","10462","10463","10464","10465","10466","10467","10468","10469","10470","10471","10472","10473","10474","10475","11370"]

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
                        :lng,
                        :accuracy

  validates_uniqueness_of :lat, :scope => :lng
  validate :ensure_at_least_one_neighborhood

  class << self
    def for_full_address(address)
      return unless address
      location = GoogleGeocoder.geocode(address)
      if location.full_address.present? && location.accuracy == 8
        address              = Address.find_or_initialize_by_lat_and_lng(location.lat, location.lng)
        address.full_address = location.full_address
        address.street       = location.street_address
        address.city         = "New York"
        address.state        = location.state
        address.zip          = location.zip
        address.accuracy     = location.accuracy
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
