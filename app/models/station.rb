class Station < ActiveRecord::Base
  acts_as_mappable

  validates_presence_of :name
  validates_uniqueness_of :lat, :scope => :lng
end
