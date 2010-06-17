class Image < ActiveRecord::Base
  has_attached_file :asset,
                    :styles => { :medium => "300x300", :thumb => "100x100>" },
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :path => "/:id/:style/:filename"
end
