class Image < ActiveRecord::Base
  belongs_to :apartment, :counter_cache => true

  has_attached_file :asset,
                    :styles => { :large => "625x440#",
                                 :medium => "115x115#",
                                 :thumb => "85x85#",
                                 :micro => "32x32#" },
                    :default_url => "/images/defaults/:style.png"

  validates_presence_of :apartment

  acts_as_list :scope => :apartment

  before_destroy :ensure_destroyable?

  def destroyable?
    !apartment.published? || apartment.images.count > 2
  end

  private
  def ensure_destroyable?
    destroyable?
  end
end
