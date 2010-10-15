require 'spec_helper'

describe UserMailer do
  describe "#deliver_first_apartment_notification" do
    before do
      @user = Factory(:user)
      @email = UserMailer.deliver_first_apartment_notification(@user)
    end

    it "queues the email" do
      ActionMailer::Base.deliveries.should_not be_empty
    end

    it "sets the recipients appropriately" do
      @email.to.should == [@user.email]
    end

    it "sets the subject appropriately" do
      @email.subject.should == "Thanks for creating a listing on Cozily"
    end

    it "includes the user's first name" do
      @email.body.should include("Hello #{@user.first_name}")
    end
  end

  describe "#deliver_finder_summary" do
    before do
      @user = Factory(:user)
      @email = UserMailer.deliver_finder_summary(@user)
    end

    it "queues the email" do
      ActionMailer::Base.deliveries.should_not be_empty
    end

    it "sets the recipients appropriately" do
      @email.to.should == [@user.email]
    end

    it "sets the subject appropriately" do
      @email.subject.should == "Your Weekly Match Summary from Cozily"
    end

    it "includes the user's first name" do
      @email.body.should include("Hello #{@user.first_name}")
    end
  end

  describe "#deliver_lister_summary" do
    before do
      @user = Factory(:user)
      @published_apartment = Factory(:apartment,
                                     :user => @user,
                                     :state => 'published')
      @unpublished_apartment = Factory(:apartment,
                                       :user => @user,
                                       :state => 'unpublished')
      @email = UserMailer.deliver_lister_summary(@user)
    end

    it "queues the email" do
      ActionMailer::Base.deliveries.should_not be_empty
    end

    it "sets the recipients appropriately" do
      @email.to.should == [@user.email]
    end

    it "sets the subject appropriately" do
      @email.subject.should == "Your Weekly Listing Summary from Cozily"
    end

    it "includes the user's first name" do
      @email.body.should include("Hello #{@user.first_name}")
    end
  end
end
