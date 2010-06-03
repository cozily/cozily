class Apartment < ActiveRecord::Base
  belongs_to :address

  validates_presence_of :address,
                        :rent,
                        :bedrooms,
                        :bathrooms,
                        :square_footage,
                        :description

  accepts_nested_attributes_for :address
end
