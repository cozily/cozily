require 'spec_helper'

describe MatchNotifierJob do
  describe "#perform" do
    before do
      @user, @apartment = Factory(:email_confirmed_user), Factory(:apartment)
      Apartment.stub!(:find).and_return(@apartment)
      @apartment.stub!(:match_for?).and_return(true)
      @match_notifier_job = MatchNotifierJob.new(@apartment)
    end

    it "emails matching users when the apartment is published" do
      lambda {
        @match_notifier_job.perform
      }.should change(Delayed::Job, :count).by(1)
      Delayed::Job.last.handler.should =~ /:deliver_new_match_notification/
    end

    it "creates a MatchNotification record for the user and apartment" do
      lambda {
        @match_notifier_job.perform
      }.should change(MatchNotification, :count).by(1)
    end

    it "does not email matching users who do not want to be emailed" do
      @user.update_attribute(:receive_match_notifications, false)
      lambda {
        @match_notifier_job.perform
      }.should_not change(Delayed::Job, :count)
    end

    it "does not email matching users who have already been emailed" do
      MatchNotification.create(:user => @user, :apartment => @apartment)
      lambda {
        @match_notifier_job.perform
      }.should_not change(Delayed::Job, :count)
    end

    it "does not email non-matching users when the apartment is published" do
      @apartment.stub!(:match_for?).and_return(false)
      lambda {
        @match_notifier_job.perform
      }.should_not change(Delayed::Job, :count)
    end    
  end  
end