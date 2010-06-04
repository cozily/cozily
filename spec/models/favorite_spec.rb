require 'spec_helper'

describe Favorite do
  before do
    Factory(:favorite)
  end

  [:user, :apartment].each do |assoc|
    it { should belong_to(assoc) }
    it { should validate_presence_of(assoc) }
  end

  it { should validate_uniqueness_of(:apartment_id, :scope => :user_id)}
end
