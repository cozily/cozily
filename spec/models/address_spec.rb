require 'spec_helper'

describe Address do
  it { should belong_to :neighborhood }
  it { should have_many(:apartments, :dependent => :destroy) }

  [:full_address, :street, :city, :state, :zip, :lat, :lng].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
