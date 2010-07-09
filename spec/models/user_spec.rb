require 'spec_helper'

describe User do
  it { should have_many(:apartments, :dependent => :destroy) }
  it { should have_many(:favorites, :dependent => :destroy) }
  it { should have_many(:favorite_apartments, :through => :favorites, :source => :apartment) }
  it { should have_many(:flags, :dependent => :destroy) }
  it { should have_many(:flagged_apartments, :through => :flags, :source => :apartment) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }

  describe "#unread_message_count" do
    it "should return the number of unread messages for the user" do
      user = Factory(:user)
      Factory(:message,
              :receiver => user,
              :read_at => Date.yesterday)
      Factory(:message,
              :receiver => user)

      user.unread_message_count.should == 1
    end
  end
end
