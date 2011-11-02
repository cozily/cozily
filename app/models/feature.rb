class Feature < ActiveRecord::Base
  validates_uniqueness_of :name, :scope => :category

  has_many :apartment_features, :dependent => :destroy
end
