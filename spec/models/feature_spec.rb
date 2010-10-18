require 'spec_helper'

describe Feature do
  before do
    Factory(:feature)  
  end

  it { should validate_uniqueness_of(:name) }
  it { should have_many(:apartment_features) }
end
