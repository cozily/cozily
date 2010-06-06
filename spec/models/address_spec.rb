require 'spec_helper'

describe Address do
  it { should belong_to :neighborhood }

  [:street, :city, :state, :zip].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
