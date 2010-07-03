require 'spec_helper'

describe Address do
  it { should have_many(:apartments, :dependent => :destroy) }
  it { should have_many(:address_neighborhoods, :dependent => :destroy) }
  it { should have_many(:neighborhoods, :through => :address_neighborhoods) }

  [:full_address, :street, :city, :state, :zip, :lat, :lng].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
