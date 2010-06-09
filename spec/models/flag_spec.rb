require 'spec_helper'

describe Flag do
  before do
    Factory(:flag)
  end

  it { should belong_to(:apartment, :counter_cache => true) }
  it { should belong_to(:user) }

  it { should validate_uniqueness_of(:apartment_id, :scope => :user_id) }
end
