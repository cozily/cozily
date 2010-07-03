class Flag < ActiveRecord::Base
  belongs_to :apartment, :counter_cache => true
  belongs_to :user

  validates_uniqueness_of :apartment_id, :scope => :user_id

  fires :created,
        :on => :create,
        :actor => :user,
        :secondary_subject => :apartment

  fires :destroyed,
        :on => :destroy,
        :actor => :user,
        :secondary_subject => :apartment
end
