require 'spec_helper'

describe Address do
  it { should have_many(:apartments, :dependent => :destroy) }
  it { should have_many(:address_neighborhoods, :dependent => :destroy) }
  it { should have_many(:neighborhoods, :through => :address_neighborhoods) }

  [:full_address, :street, :city, :state, :zip, :lat, :lng].each do |attr|
    it { should validate_presence_of(attr) }
  end

  it "should be invalid with a neighborhood outside of new york" do
    address = Factory.build(:address, :full_address => "1719 Q St NW 20009")
    address.should be_invalid
  end
end
