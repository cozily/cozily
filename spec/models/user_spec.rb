require 'spec_helper'

describe User do
  it { should have_one(:profile, :dependent => :destroy) }
  it { should have_many(:apartments, :dependent => :destroy) }
  it { should have_many(:favorites, :dependent => :destroy) }
  it { should have_many(:favorite_apartments, :through => :favorites, :source => :apartment) }
  it { should have_many(:flags, :dependent => :destroy) }
  it { should have_many(:flagged_apartments, :through => :flags, :source => :apartment) }
  it { should have_many(:roles, :through => :user_roles) }
  it { should have_many(:timeline_events, :foreign_key => "actor_id", :dependent => :destroy) }
  it { should have_many(:user_roles, :dependent => :destroy) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }

  describe "#matches" do
    before do
      @apt1 = Factory(:apartment,
                      :bedrooms => 1,
                      :rent => 1500,
                      :state => "listed")
      @apt2 = Factory(:apartment,
                      :bedrooms => 2,
                      :rent => 2100,
                      :state => "listed")
      @user = Factory(:user)
    end

    context "when the user has a complete profile" do
      before do
        @profile = Factory(:profile,
                           :user => @user,
                           :rent => 1500,
                           :bedrooms => 1,
                           :neighborhoods => [@apt1.neighborhoods.first])
      end

      it "returns apartments that match all of the user's requirements" do
        @user.matches.should == [@apt1]
      end

      it "returns an empty array when rent does not match" do
        @apt1.update_attribute(:rent, 1501)
        @user.matches.should == []
      end

      it "returns an empty array when bedrooms does not match" do
        @apt1.update_attribute(:bedrooms, 0)
        @user.matches.should == []
      end

      it "returns an empty array when neighborhood does not match" do
        @apt1.update_attribute(:address, Address.last)
        @user.matches.should == []
      end
    end

    context "when profile is empty" do
      before do
        @profile = Factory(:profile,
                           :user => @user,
                           :rent => nil,
                           :bedrooms => nil,
                           :neighborhoods => [])
      end

      it "returns all listed apartments" do
        @user.matches.should == [@apt1, @apt2]
      end
    end

    context "when the user didn't specify rent" do
      before do
        before do
          @profile = Factory(:profile,
                             :user => @user,
                             :rent => nil,
                             :bedrooms => 1,
                             :neighborhoods => [@apt1.neighborhoods.first])
        end

        it "ignores rent" do
          @apt1.update_attribute(:rent, 1501)
          @user.matches.should == [@apt1]
        end
      end
    end

    context "when the user didn't specify bedrooms" do
      before do
        before do
          @profile = Factory(:profile,
                             :user => @user,
                             :rent => 1500,
                             :bedrooms => nil,
                             :neighborhoods => [@apt1.neighborhoods.first])
        end

        it "ignores bedrooms" do
          @apt1.update_attribute(:bedrooms, 0)
          @user.matches.should == [@apt1]
        end
      end
    end

    context "when the user didn't specify neighborhoods" do
      before do
        before do
          @profile = Factory(:profile,
                             :user => @user,
                             :rent => 1500,
                             :bedrooms => nil,
                             :neighborhoods => [])
        end

        it "ignores neighborhood" do
          @user.matches.should == [@apt1]
        end
      end
    end
  end
end
