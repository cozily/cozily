class Neighborhood < ActiveRecord::Base
  has_many :address_neighborhoods, :dependent => :destroy
  has_many :addresses, :through => :address_neighborhoods

  has_friendly_id :name, :use_slug => true

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [ :city, :state, :country, :borough ]

  default_scope :order => "name"

  class << self
    def for_lat_and_lng(lat, lng)
      neighborhoods = []
      response = JSON.parse(Yelp.new.neighborhood_for_lat_and_lng(lat, lng))
      if response.has_key?("neighborhoods") && response["neighborhoods"].present?
        response["neighborhoods"].each do |res|
          neighborhood = Neighborhood.find_by_name_and_city_and_borough_and_state_and_country(res["name"], res["city"], res["borough"], res["state"], res["country"])
          neighborhoods << neighborhood if neighborhood
        end
      end
      neighborhoods
    end

    def to_autocomplete
      all.map { |n| { :label => n.name, :id => n.id } }
    end

    def to_dropdown
      Neighborhood.ascend_by_name.map {|n| [n.name, n.id]}
    end
  end

  def apartments
    Apartment.joins(:address => :neighborhoods).where("address_neighborhoods.neighborhood_id" => self.id)
  end

  def published_apartments
    apartments.where(state: "published")
  end
end
