require 'spec_helper'

describe Neighborhood do
  it { should have_many(:addresses) }
  it { should have_many(:apartments, :through => :addresses) }

  it { should validate_presence_of(:name) }
end
