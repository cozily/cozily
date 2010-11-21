require 'spec_helper'

describe ClearanceMailer do
  describe "#deliver_confirmation" do
    before do
      @user = Factory(:user)
      @email = ClearanceMailer.confirmation(@user).deliver
    end

    it "queues the email" do
      ActionMailer::Base.deliveries.should_not be_empty
    end

    it "sets the recipients appropriately" do
      @email.to.should == [@user.email]
    end

    it "sets the subject appropriately" do
      @email.subject.should == "Confirm your email address"
    end

    it "includes the user's first name" do
      @email.body.should include("Hello #{@user.first_name}")
    end
  end
end