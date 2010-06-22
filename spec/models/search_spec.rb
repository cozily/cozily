require 'spec_helper'

describe Search do
  context "when searching by number of bedrooms" do
    before do
      Factory(:apartment, :bedrooms => 1, :state => 'published')
      Factory(:apartment, :bedrooms => 2, :state => 'published')
      Factory(:apartment, :bedrooms => 4, :state => 'published')
      @search = Search.new
      @search.min_bedrooms = 2
      @search.max_bedrooms = 3
    end

    it "returns the correct number of apartments with bedrooms between min and max" do
      @search.results.count.should == 1
    end
  end

  context "when searching by number of bathrooms" do
    before do
      Factory(:apartment, :bathrooms => 0.5, :state => 'published')
      Factory(:apartment, :bathrooms => 1, :state => 'published')
      Factory(:apartment, :bathrooms => 2.5, :state => 'published')
      @search = Search.new(:min_bathrooms => 0.5, :max_bathrooms => 2)
    end

    it "returns the correct number of apartments with bathrooms between min and max" do
      @search.results.count.should == 2
    end
  end

  context "when searching by rent" do
    before do
      Factory(:apartment, :rent => 1900, :state => 'published')
      Factory(:apartment, :rent => 2200, :state => 'published')
      Factory(:apartment, :rent => 2750, :state => 'published')
      @search = Search.new(:min_rent => 1901, :max_rent => 2700)
    end

    it "returns the correct number of apartments with rent between min and max" do
      @search.results.count.should == 1
    end
  end

  context "when searching by square footage" do
    before do
      Factory(:apartment, :square_footage => 225, :state => 'published')
      Factory(:apartment, :square_footage => 350, :state => 'published')
      Factory(:apartment, :square_footage => 720, :state => 'published')
      @search = Search.new(:min_square_footage => 250, :max_square_footage => 700)
    end

    it "returns the correct number of apartments with square footage between min and max" do
      @search.results.count.should == 1
    end
  end

  context "when searching by neighborhood" do
    before do
      Factory(:apartment,
              :address => Factory(:address, :full_address => "546 Henry St, Brooklyn, NY 11231, USA"),
              :state => 'published')
      Factory(:apartment,
              :address => Factory(:address, :full_address => "111 W 74th St, New York, NY 10023, USA"),
              :state => 'published')
      @search = Search.new(:neighborhood_ids => Neighborhood.find_all_by_name("Upper West Side").map(&:id))
    end

    it "returns the correct number of apartments in that neighborhood" do
      @search.results.count.should == 1
    end
  end
end
