require 'spec_helper'

describe ApartmentFeature do
  before do
    Factory(:apartment_feature)
  end

  it { should belong_to(:apartment) }
  it { should belong_to(:feature) }

  it { should validate_uniqueness_of(:feature_id, :scope => :apartment_id) }
end
