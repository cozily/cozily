require 'spec_helper'

describe Apartment do
  it { should belong_to(:address) }
  it { should belong_to(:user) }

  it { should have_many(:apartment_features, :dependent => :destroy) }
  it { should have_many(:favorites, :dependent => :destroy) }
  it { should have_many(:features, :through => :apartment_features) }

  [:address, :user, :rent, :bedrooms, :bathrooms, :square_footage].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
