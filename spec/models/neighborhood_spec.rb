require 'spec_helper'

describe Neighborhood do
  it { should have_many(:address_neighborhoods, :dependent => :destroy) }
  it { should have_many(:addresses, :through => :address_neighborhoods) }

  it { should validate_presence_of(:name) }

  describe ".for_lat_and_lng" do
    it "finds a neighorhood based on the response from Yelp" do
      lambda {
        @neighborhood = Neighborhood.for_lat_and_lng(40.6824793, -74.0003197)
      }.should_not change(Neighborhood, :count)

      @neighborhood = Neighborhood.last
      @neighborhood.name.should == "Carroll Gardens"
      @neighborhood.city.should == "New York"
      @neighborhood.state.should == "NY"
      @neighborhood.country.should == "USA"
      @neighborhood.borough.should == "Brooklyn"
    end

    it "should not create a new neighborhood outside of New York" do
      lambda {
        @neighborhood = Neighborhood.for_lat_and_lng(38.911385, -77.039474)
      }.should_not change(Neighborhood, :count)
    end
  end
end
