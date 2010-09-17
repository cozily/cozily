class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :apartment
  
  validates_presence_of :user, :apartment
end
