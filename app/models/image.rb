class Image < ActiveRecord::Base
  belongs_to :apartment, :counter_cache => true

  has_attached_file :asset,
                    :styles => { :large => "625x440#",
                                 :medium => "115x115#",
                                 :thumb => "85x85#",
                                 :micro => "32x32#" },
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :path => "/:id/:style/:filename",
                    :default_url => "/images/defaults/:style.png"

  validates_presence_of :apartment

  acts_as_list :scope => :apartment

  before_destroy :ensure_destroyable?

  private
  def ensure_destroyable?
    (apartment.listed? && apartment.images.count == 1) ? false : true
  end
end
