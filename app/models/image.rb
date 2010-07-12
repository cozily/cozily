class Image < ActiveRecord::Base
  belongs_to :apartment, :counter_cache => true

  has_attached_file :asset,
                    :styles => { :large => "625x440", :thumb => "85x85" },
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :path => "/:id/:style/:filename"

  validates_presence_of :apartment

  acts_as_list :scope => :apartment
end
