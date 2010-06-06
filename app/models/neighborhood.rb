class Neighborhood < ActiveRecord::Base
  has_many :addresses
  has_many :apartments, :through => :addresses

  has_friendly_id :name, :use_slug => true

  validates_presence_of :name
end
