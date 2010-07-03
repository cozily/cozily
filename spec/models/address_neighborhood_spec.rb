require 'spec_helper'

describe AddressNeighborhood do
  before do
    Factory(:address_neighborhood)
  end
  
  it { should belong_to :address }
  it { should belong_to :neighborhood }

  it { should validate_uniqueness_of(:address_id, :scope => :neighborhood_id) }
end
