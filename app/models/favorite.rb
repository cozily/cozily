class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :apartment

  validates_presence_of :user, :apartment

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
