class Photo < ActiveRecord::Base
  belongs_to :apartment, :counter_cache => true

  validates_presence_of :apartment

  acts_as_list :scope => :apartment

  mount_uploader :image, ImageUploader
end
