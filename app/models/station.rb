class Station < ActiveRecord::Base
  acts_as_mappable

  has_many :station_trains, :dependent => :destroy
  has_many :trains, :through => :station_trains

  validates_presence_of :name
  validates_uniqueness_of :lat, :scope => :lng
end
