require 'spec_helper'

describe Address do
  [:street, :city, :state, :zip].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
