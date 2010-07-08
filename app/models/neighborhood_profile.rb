class NeighborhoodProfile < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :profile

  validates_uniqueness_of :neighborhood_id, :scope => :profile_id
end