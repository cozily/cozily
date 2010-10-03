require 'spec_helper'

describe UsersHelper do
  describe "profile_summary" do
    before do
      @neighborhood = Neighborhood.first
      @profile = Factory(:profile,
                         :bedrooms => 1,
                         :rent => 1500,
                         :neighborhoods => [@neighborhood])
    end

    it "returns a summary including the bedrooms, rent, and neighborhoods" do
      helper.profile_summary(@profile).should == "matching apartments with at least 1 bedroom under $1,500 in #{link_to(@neighborhood.name, @neighborhood)}"
    end

    it "returns an appropriate summary when neighborhoods is empty" do
      @profile.update_attribute(:neighborhoods, [])
      helper.profile_summary(@profile).should == "matching apartments with at least 1 bedroom under $1,500 in all neighborhoods"
    end

    it "returns an appropriate summary when rent is nil and neighborhoods is empty" do
      @profile.update_attributes(:rent => nil, :neighborhoods => [])
      helper.profile_summary(@profile).should == "matching apartments with at least 1 bedroom regardless of rent in all neighborhoods"
    end

    it "returns an appropriate summary when bedrooms is nil and rent is nil and neighborhoods is empty" do
      @profile.update_attributes(:bedrooms => nil, :rent => nil, :neighborhoods => [])
      helper.profile_summary(@profile).should == "matching apartments with any number of bedrooms regardless of rent in all neighborhoods"
    end

    it "returns an appropriate summary when bedrooms is nil and neighborhoods is empty" do
      @profile.update_attributes(:bedrooms => nil, :neighborhoods => [])
      helper.profile_summary(@profile).should == "matching apartments with any number of bedrooms under $1,500 in all neighborhoods"
    end

    it "returns an appropraite summary when profile is nil" do
      helper.profile_summary(nil).should == "matching apartments with any number of bedrooms regardless of rent in all neighborhoods"
    end
  end
end