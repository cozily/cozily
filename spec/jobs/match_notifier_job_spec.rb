require 'spec_helper'

describe MatchNotifierJob do
  describe "#perform" do
    before do
      @user, @apartment = Factory(:user), Factory(:apartment)
      Apartment.stub!(:find).and_return(@apartment)
      @apartment.stub!(:match_for?).and_return(true)
    end

    it "emails matching users when the apartment is published" do
      lambda {
        MatchNotifierJob.perform(@apartment.id)
      }.should change(ActionMailer::Base.deliveries, :count).by(1)
      ActionMailer::Base.deliveries.last.subject.should =~ /A new apartment/
    end

    it "creates a MatchNotification record for the user and apartment" do
      lambda {
        MatchNotifierJob.perform(@apartment.id)
      }.should change(MatchNotification, :count).by(1)
    end

    it "does not email matching users who do not want to be emailed" do
      @user.update_attribute(:receive_match_notifications, false)
      lambda {
        MatchNotifierJob.perform(@apartment.id)
      }.should_not change(ActionMailer::Base.deliveries, :count)
    end

    it "does not email matching users who have already been emailed" do
      MatchNotification.create(:user => @user, :apartment => @apartment)
      lambda {
        MatchNotifierJob.perform(@apartment.id)
      }.should_not change(ActionMailer::Base.deliveries, :count)
    end

    it "does not email non-matching users when the apartment is published" do
      @apartment.stub!(:match_for?).and_return(false)
      lambda {
        MatchNotifierJob.perform(@apartment.id)
      }.should_not change(ActionMailer::Base.deliveries, :count)
    end
  end
end
