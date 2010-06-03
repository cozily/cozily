require 'spec_helper'

describe Apartment do
  it { should belong_to :address }

  [:address, :rent, :bedrooms, :bathrooms, :square_footage, :description].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
