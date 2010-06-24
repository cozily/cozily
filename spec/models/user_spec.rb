require 'spec_helper'

describe User do
  it { should have_many(:apartments, :dependent => :destroy) }
  it { should have_many(:contacts, :dependent => :destroy) }
  it { should have_many(:favorites, :dependent => :destroy) }
  it { should have_many(:favorite_apartments, :through => :favorites, :source => :apartment) }
  it { should have_many(:flags, :dependent => :destroy) }
  it { should have_many(:flagged_apartments, :through => :flags, :source => :apartment) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
end
