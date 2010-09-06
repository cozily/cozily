class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :neighborhood_profiles
  has_many :neighborhoods, :through => :neighborhood_profiles
end