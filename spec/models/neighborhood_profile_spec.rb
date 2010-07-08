require 'spec_helper'

describe NeighborhoodProfile do
  before do
    Factory(:neighborhood_profile)
  end

  it { should belong_to :neighborhood }
  it { should belong_to :profile }

  it { should validate_uniqueness_of(:neighborhood_id, :scope => :profile_id) }
end
