class UserActivity < ActiveRecord::Base
  belongs_to :user

  validates_uniqueness_of :user_id, :scope => :date

  default_scope :order => "date desc"
end
