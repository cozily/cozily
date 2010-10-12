require 'spec_helper'

describe UserActivity do
  before do
    Factory(:user_activity)
  end

  it { should validate_uniqueness_of(:user_id, :scope => :date) }
end
