require 'spec_helper'

describe UserRole do
  before do
    Factory(:user_role)
  end

  it { should belong_to(:user) }
  it { should belong_to(:role) }

  it { should validate_uniqueness_of(:role_id, :scope => :user_id) }
end
