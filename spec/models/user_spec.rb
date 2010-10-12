require 'spec_helper'

describe User do
  it { should have_one(:profile, :dependent => :destroy) }
  it { should have_many(:activities, :class_name => "UserActivity", :dependent => :destroy) }
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

  describe "validations" do
    it "should be invalid if phone number is nil and there are published apartments" do
      @user = Factory(:user, :phone => nil)
      Factory(:apartment, :user => @user, :state => "published")
      @user.reload.should be_invalid
      @user.should have(1).error_on(:phone)
    end

    it "should be invalid if the user is a lister and doesn't have a phone" do
      @user = Factory.build(:user, :roles => [Role.find_by_name("lister")], :phone => nil)
      @user.should be_invalid
      @user.should have(1).error_on(:phone)
    end

    it "should be invalid if roles is empty" do
      @user = Factory.build(:user, :roles => [])
      @user.should be_invalid
      @user.should have(1).error_on(:roles)
    end
  end

  describe "#after_create" do
    it "should send a confirmation email later" do
      lambda {
        Factory(:user)
      }.should change(Delayed::Job, :count).by(1)

      Delayed::Job.last.handler.should =~ /:deliver_confirmation/
    end
  end

  it "should strip non-digit characters from phone" do
    user = Factory.build(:user, :phone => "(202) 270 - 7370")
    user.save
    user.phone.should == "2022707370"
  end

  describe ".finder" do
    before do
      @user = Factory(:user)
      @user.roles << Role.find_by_name("lister")
      @user.roles.should include(Role.find_by_name("finder"))
    end

    it "returns users that have the finder role" do
      User.finder.should == [@user]
    end

    it "does not return users that do not have the finder role" do
      UserRole.find_by_user_id_and_role_id(@user.id, Role.find_by_name("finder").id).destroy
      User.finder.should == []
    end
  end

  describe "#matches" do
    before do
      @apt1 = Factory(:apartment,
                      :bedrooms => 1,
                      :rent => 1500,
                      :state => "published")
      @apt2 = Factory(:apartment,
                      :bedrooms => 2,
                      :rent => 2100,
                      :state => "published")
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

      it "does not return matching apartments that the user created" do
        @apt1.update_attribute(:user, @user)
        @user.matches.should == []
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

      it "returns all published apartments" do
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
