class Feature < ActiveRecord::Base
  validates_uniqueness_of :name

  has_many :apartment_features, :dependent => :destroy
end
