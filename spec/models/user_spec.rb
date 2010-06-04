require 'spec_helper'

describe User do
  it { should have_many(:favorites, :dependent => :destroy) }
  it { should have_many(:apartments, :through => :favorites) }
end