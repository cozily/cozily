class ProfileFeature < ActiveRecord::Base
  belongs_to :profile
  belongs_to :feature

  validates_uniqueness_of :feature_id, :scope => :profile_id
end

