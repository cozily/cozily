require 'spec_helper'

describe ProfileFeature do
  before do
    Factory(:profile_feature)
  end

  it { should belong_to(:profile) }
  it { should belong_to(:feature) }

  it { should validate_uniqueness_of(:feature_id, :scope => :profile_id) }
end

