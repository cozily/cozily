require 'spec_helper'

describe Building do
  it { should have_many(:apartments, :dependent => :destroy) }
  it { should have_many(:building_neighborhoods, :dependent => :destroy) }
  it { should have_many(:neighborhoods, :through => :building_neighborhoods) }

  [:full_address, :street, :city, :state, :zip, :lat, :lng, :accuracy].each do |attr|
    it { should validate_presence_of(attr) }
  end

  it "should be invalid with a neighborhood outside of new york" do
    building = Factory.build(:building, :full_address => "1719 Q St NW 20009")
    building.should be_invalid
  end
end
