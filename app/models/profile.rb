class Profile < ActiveRecord::Base
  SUBLETS = { "include them" => 0,
              "exclude them" => 1,
              "only show them" => 2 }

  belongs_to :user
  has_many :neighborhood_profiles, :include => :neighborhood, :order => "neighborhoods.name"
  has_many :neighborhoods, :through => :neighborhood_profiles

  validates_numericality_of :bedrooms, :only_integer => true, :allow_nil => true
  validates_numericality_of :rent, :only_integer => true, :allow_nil => true
  validates_numericality_of :sublets, :only_integer => true

  def exclude_sublets?
    sublets == SUBLETS["exclude them"]
  end

  def only_sublets?
    sublets == SUBLETS["only show them"]
  end
end