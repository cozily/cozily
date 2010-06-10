class Apartment < ActiveRecord::Base
  belongs_to :address
  belongs_to :user

  has_many :apartment_features, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :features, :through => :apartment_features

  has_friendly_id :full_address, :use_slug => true

  validates_presence_of :address,
                        :user,
                        :rent,
                        :bedrooms,
                        :bathrooms,
                        :square_footage

  accepts_nested_attributes_for :address

  delegate :full_address, :neighborhood, :to => :address

  default_scope :order => "apartments.created_at"

  state_machine :state, :initial => :unpublished do
    event :publish do
      transition :unpublished => :published
    end

    event :unpublish do
      transition :published => :unpublished
    end
  end
end
