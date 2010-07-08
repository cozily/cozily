require 'spec_helper'

describe Profile do
  before do
    Factory(:profile)
  end

  it { should belong_to :user }
  it { should have_many :neighborhoods }
end
