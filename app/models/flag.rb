class Flag < ActiveRecord::Base
  belongs_to :apartment, :counter_cache => true
  belongs_to :user

  validates_uniqueness_of :apartment_id, :scope => :user_id
end
