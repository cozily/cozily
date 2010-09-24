require 'spec_helper'

describe ClearanceMailer do
  describe "#deliver_confirmation" do
    before do
      @user = Factory(:user)
    end

    it "queues the email" do
      ClearanceMailer.deliver_confirmation(@user)
      ActionMailer::Base.deliveries.should_not be_empty
    end

    it "sets the recipients appropriately" do
      confirmation_email = ClearanceMailer.deliver_confirmation(@user)
      confirmation_email.to.should == [@user.email]
    end

    it "sets the subject appropriately" do
      confirmation_email = ClearanceMailer.deliver_confirmation(@user)
      confirmation_email.subject.should == "Confirm your email address"
    end

    it "includes the user's first name" do
      confirmation_email = ClearanceMailer.deliver_confirmation(@user)
      confirmation_email.body.should include("Hello #{@user.first_name}")
    end
  end
end