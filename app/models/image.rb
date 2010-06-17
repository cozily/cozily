class Image < ActiveRecord::Base
  belongs_to :apartment, :counter_cache => true

  has_attached_file :asset,
                    :styles => { :medium => "300x300", :thumb => "100x100>" },
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :path => "/:id/:style/:filename"

  validates_presence_of :apartment
end
