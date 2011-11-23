require 'spec_helper'

describe Feature do
  before do
    Factory(:feature)
  end

  it { should validate_uniqueness_of(:name, :scope => :category) }
  it { should have_many(:apartment_features) }
end
