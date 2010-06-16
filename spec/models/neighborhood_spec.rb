require 'spec_helper'

describe Neighborhood do
  it { should have_many(:addresses) }
  it { should have_many(:apartments, :through => :addresses) }

  it { should validate_presence_of(:name) }

  describe ".for_lat_and_lng" do
    it "creates a neighorhood based on the response from Yelp" do
      lambda {
        Neighborhood.for_lat_and_lng(40.6824793, -74.0003197)
      }.should change(Neighborhood, :count).by(1)

      neighborhood = Neighborhood.last
      neighborhood.name.should == "Carroll Gardens"
      neighborhood.city.should == "New York"
      neighborhood.state.should == "NY"
      neighborhood.country.should == "USA"
      neighborhood.borough.should == "Brooklyn"
    end
  end
end
