class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :neighborhood_profiles, :include => :neighborhood, :order => "neighborhoods.name"
  has_many :neighborhoods, :through => :neighborhood_profiles

  validates_numericality_of :bedrooms, :only_integer => true, :allow_nil => true
  validates_numericality_of :rent, :only_integer => true, :allow_nil => true
end