require 'spec_helper'

describe BuildingNeighborhood do
  before do
    Factory(:building_neighborhood)
  end

  it { should belong_to :building }
  it { should belong_to :neighborhood }

  it { should validate_uniqueness_of(:building_id, :scope => :neighborhood_id) }
end
