class BuildingNeighborhood < ActiveRecord::Base
  belongs_to :building
  belongs_to :neighborhood

  validates_uniqueness_of :building_id, :scope => :neighborhood_id
end
