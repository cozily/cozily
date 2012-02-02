require 'spec_helper'

describe Search, sunspot: true do
  it "should perform a search for Apartments" do
    @search = Search.new
    @search.results
    Sunspot.session.should be_a_search_for(Apartment)
  end

  context "when searching by number of bedrooms" do
    it "returns the correct number of apartments with bedrooms between min and max" do
      @search = Search.new(:min_bedrooms => 2)
      @search.results
      Sunspot.session.should have_search_params(:with, Proc.new {
        with(:published, true)
        with(:bedrooms).greater_than(2)
        with(:bedrooms).equal_to(2)
      })

    end
  end

  context "when searching by rent" do
    it "returns the correct number of apartments with rent between min and max" do
      @search = Search.new(:max_rent => 2700)
      @search.results
      Sunspot.session.should have_search_params(:with, Proc.new {
        with(:published, true)
        with(:rent).less_than(2700)
        with(:rent).equal_to(2700)
      })
    end
  end

  context "when searching by neighborhood" do
    it "returns the correct number of apartments in that neighborhood" do
      neighborhood = Neighborhood.find_by_name("Upper West Side")
      @search = Search.new(:neighborhood_id => neighborhood.id)
      @search.results
      Sunspot.session.should have_search_params(:with, Proc.new {
        with(:published, true)
        with(:neighborhood_ids, neighborhood.id)
      })
    end
  end
end
