require 'spec_helper'

describe MatchMailer do
  describe "#deliver_new_match_notification" do
    before do
      Apartment.destroy_all
      Address.destroy_all
      @apartment, @user = Factory(:apartment), Factory(:user)
    end

    it "queues the email" do
      MatchMailer.deliver_new_match_notification(@apartment, @user)
      ActionMailer::Base.deliveries.should_not be_empty
    end

    it "sets the recipients appropriately" do
      match_email = MatchMailer.deliver_new_match_notification(@apartment, @user)
      match_email.to.should == [@user.email]
    end

    it "sets the subject appropriately" do
      match_email = MatchMailer.deliver_new_match_notification(@apartment, @user)
      match_email.subject.should == "A new apartment in #{@apartment.neighborhoods.map(&:name).to_sentence} was published on Cozily..."
    end

    it "includes the user's first name" do
      match_email = MatchMailer.deliver_new_match_notification(@apartment, @user)
      match_email.body.should include("Hello #{@user.first_name}")
    end

    it "includes the apartment's neighborhoods" do
      match_email = MatchMailer.deliver_new_match_notification(@apartment, @user)
      match_email.body.should include(@apartment.neighborhoods.map(&:name).to_sentence)
    end
  end
end
