require 'spec_helper'

describe Profile do
  before do
    Factory(:profile)
  end

  it { should belong_to :user }
  it { should have_many :neighborhoods }

  it { should validate_numericality_of(:bedrooms, :only_integer => true, :allow_nil => true) }
  it { should validate_numericality_of(:rent, :only_integer => true, :allow_nil => true) }
  it { should validate_numericality_of(:sublets, :only_integer => true) }
end
