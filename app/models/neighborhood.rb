class Neighborhood < ActiveRecord::Base
  has_many :addresses
  has_many :apartments, :through => :addresses

  has_friendly_id :name, :use_slug => true

  validates_presence_of :name

  class << self
    def for_lat_and_lng(lat, lng)
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
      neighborhood
    end

    def to_dropdown
      all.map {|n| [n.name, n.id]}
    end
  end
end
