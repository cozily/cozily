class ApartmentFeature < ActiveRecord::Base
  belongs_to :apartment
  belongs_to :feature

  validates_uniqueness_of :feature_id, :scope => :apartment_id
end
