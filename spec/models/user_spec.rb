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
      Factory(:published_apartment, :user => @user)
      @user.reload.should be_invalid
      @user.should have(1).error_on(:phone)
    end

    it "should be invalid if the user is a lister and doesn't have a phone" do
      @user = Factory.build(:lister, :phone => nil)
      @user.should be_invalid
      @user.should have(1).error_on(:phone)
    end

    it "should be invalid if roles is empty" do
      @user = Factory.build(:user, :role_ids => [])
      @user.should be_invalid
      @user.should have(1).error_on(:roles)
    end
  end

  describe "#after_create" do
    it "should send a confirmation email later" do
      lambda {
        Factory(:user)
      }.should change(ActionMailer::Base.deliveries, :count).by(1)

      ActionMailer::Base.deliveries.last.subject.should == "Thanks for creating an account on Cozily"
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

  describe ".lister" do
    before do
      @user = Factory(:lister)
      @user.roles.should include(Role.find_by_name("lister"))
    end

    it "returns users that have the lister role" do
      User.lister.should == [@user]
    end

    it "does not return users that do not have the lister role" do
      UserRole.find_by_user_id_and_role_id(@user.id, Role.find_by_name("lister").id).destroy
      User.lister.should == []
    end
  end

  describe ".send_finder_summary_emails" do
    before do
      @finder = Factory(:user)
    end

    it "should email finders" do
      lambda {
        User.send_finder_summary_emails
      }.should change(ActionMailer::Base.deliveries, :count).by(1)
      ActionMailer::Base.deliveries.last.subject.should == "Your Weekly Match Summary from Cozily"
    end

    it "should not email finders who have opted out of weekly summaries" do
      @finder.update_attribute(:receive_match_summaries, false)
      lambda {
        User.send_finder_summary_emails
      }.should_not change(ActionMailer::Base.deliveries, :count)
    end
  end

  describe ".send_lister_summary_emails" do
    before do
      @lister = Factory(:lister)
    end

    it "should email listers" do
      lambda {
        User.send_lister_summary_emails
      }.should change(ActionMailer::Base.deliveries, :count).by(1)
      ActionMailer::Base.deliveries.last.subject.should == "Your Weekly Listing Summary from Cozily"
    end

    it "should not email listers who have opted out of weekly summaries" do
      @lister.update_attribute(:receive_listing_summaries, false)
      lambda {
        User.send_lister_summary_emails
      }.should_not change(ActionMailer::Base.deliveries, :count)
    end
  end

  describe "#matches", sunspot: true do
    before do
      @user = Factory(:user)
      @neighborhood = Factory(:neighborhood)
    end

    context "when the user has a complete profile" do
      before do
        @profile = Factory(:profile,
                           :user => @user,
                           :rent => 1500,
                           :bedrooms => 1,
                           :neighborhoods => [@neighborhood])
        @user.matches
      end

      it "should initiate a search for apartments" do
        Sunspot.session.should be_a_search_for(Apartment)
      end

      it "returns apartments that match all of the user's requirements" do
        neighborhood_id = @neighborhood.id

        Sunspot.session.should have_search_params(:without, :user_id, @user.id)
        Sunspot.session.should have_search_params(:with, Proc.new {
          with(:published, true)
          with(:rent).less_than(1500)
          with(:rent).equal_to(1500)
          with(:bedrooms).greater_than(1)
          with(:bedrooms).equal_to(1)
          with(:neighborhood_ids, [neighborhood_id])
        })
      end
    end

    context "when profile is empty" do
      before do
        @profile = Factory(:profile,
                           :user => @user,
                           :rent => nil,
                           :bedrooms => nil,
                           :neighborhoods => [])
        @user.matches
      end

      it "searches with the default information" do
        Sunspot.session.should have_search_params(:without, :user_id, @user.id)
        Sunspot.session.should have_search_params(:with, :published, true)
      end
    end

    context "when the user didn't specify rent" do
      before do
        before do
          @profile = Factory(:profile,
                             :user => @user,
                             :rent => nil,
                             :bedrooms => 1,
                             :neighborhoods => [@neighborhood])
          @user.matches
        end

        it "ignores rent" do
          Sunspot.session.should_not have_search_params(:with, :rent)
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
                             :neighborhoods => [@neighborhood])
          @user.matches
        end

        it "ignores bedrooms" do
          Sunspot.session.should_not have_search_params(:with, :neighborhood_ids)
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
          @user.matches
        end

        it "ignores neighborhood" do
          Sunspot.session.should_not have_search_params(:with, :neighborhoods)
        end
      end
    end

    describe "sublet preference" do
      before do
        @profile = Factory(:profile,
                           :user => @user,
                           :bedrooms => nil,
                           :rent => nil)
      end

      it "returns sublets when the user includes them" do
        @profile.update_attribute(:sublets, Profile::SUBLETS["include them"])
        @user.matches
        Sunspot.session.should_not have_search_params(:with, :sublet, true)
        Sunspot.session.should_not have_search_params(:with, :sublet, false)
      end

      it "only returns sublets when the user includes them exclusively" do
        @profile.update_attribute(:sublets, Profile::SUBLETS["only show them"])
        @user.matches
        Sunspot.session.should have_search_params(:with, :sublet, true)
      end

      it "excludes sublets when the user excludes them" do
        @profile.update_attribute(:sublets, Profile::SUBLETS["exclude them"])
        @user.matches
        Sunspot.session.should have_search_params(:with, :sublet, false)
      end
    end

    describe "when the user has specified feature preferences" do
      before do
        @profile = Factory(:profile,
                           :user => @user,
                           :bedrooms => nil,
                           :rent => nil,
                           :features => [Feature.find_by_name("furnished"), Feature.find_by_name("backyard")])
        @user.matches
      end

      it "returns apartments that have the specified features" do
        Sunspot.session.should have_search_params(:with, :feature_ids, Feature.find_by_name("furnished").id)
        Sunspot.session.should have_search_params(:with, :feature_ids, Feature.find_by_name("backyard").id)
      end
    end
  end
end
