require 'spec_helper'

describe Search do
  context "when searching by number of bedrooms" do
    before do
      Factory(:apartment, :bedrooms => 1, :state => 'published')
      Factory(:apartment, :bedrooms => 2, :state => 'published')
      Factory(:apartment, :bedrooms => 4, :state => 'published')
      @search = Search.new
      @search.min_bedrooms = 2
    end

    it "returns the correct number of apartments with bedrooms between min and max" do
      @search.results.count.should == 2
    end
  end

  context "when searching by rent" do
    before do
      Factory(:apartment, :rent => 1900, :state => 'published')
      Factory(:apartment, :rent => 2200, :state => 'published')
      Factory(:apartment, :rent => 2750, :state => 'published')
      @search = Search.new(:max_rent => 2700)
    end

    it "returns the correct number of apartments with rent between min and max" do
      @search.results.count.should == 2
    end
  end

  context "when searching by neighborhood" do
    before do
      Factory(:apartment,
              :address => Factory(:address, :full_address => "546 Henry St 11231"),
              :state => 'published')
      Factory(:apartment,
              :address => Factory(:address, :full_address => "111 W 74th St 10023"),
              :state => 'published')
      @search = Search.new(:neighborhood_ids => Neighborhood.find_all_by_name("Upper West Side").map(&:id))
    end

    it "returns the correct number of apartments in that neighborhood" do
      @search.results.count.should == 1
    end
  end
end
