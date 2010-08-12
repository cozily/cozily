require 'spec_helper'

describe Role do
  before do
    Factory(:role)
  end

  it { should validate_uniqueness_of(:name) }
end
