class Apartment < ActiveRecord::Base
  belongs_to :address

  has_many :favorites, :dependent => :destroy

  has_friendly_id :full_address, :use_slug => true

  validates_presence_of :address,
                        :rent,
                        :bedrooms,
                        :bathrooms,
                        :square_footage

  accepts_nested_attributes_for :address

  delegate :full_address, :neighborhood, :to => :address

  state_machine :state, :initial => :unpublished do
    event :publish do
      transition :unpublished => :published
    end

    event :unpublish do
      transition :published => :unpublished
    end
  end
end
