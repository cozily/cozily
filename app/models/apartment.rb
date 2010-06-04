class Apartment < ActiveRecord::Base
  belongs_to :address

  has_many :favorites, :dependent => :destroy

  has_friendly_id :full_address, :use_slug => true

  validates_presence_of :address,
                        :rent,
                        :bedrooms,
                        :bathrooms,
                        :square_footage,
                        :description

  accepts_nested_attributes_for :address

  delegate :full_address, :to => :address
end
