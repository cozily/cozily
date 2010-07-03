class AddressNeighborhood < ActiveRecord::Base
  belongs_to :address
  belongs_to :neighborhood

  validates_uniqueness_of :address_id, :scope => :neighborhood_id
end
