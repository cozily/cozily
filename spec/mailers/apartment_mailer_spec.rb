require 'spec_helper'

describe ApartmentMailer do
  describe "#deliver_unpublished_stale_apartment_notification" do
    before do
      @apartment = Factory(:published_apartment)
      @email = ApartmentMailer.deliver_unpublished_stale_apartment_notification(@apartment)
    end

    it "queues the email" do
      ActionMailer::Base.deliveries.should_not be_empty
    end

    it "sets the recipients appropriately" do
      @email.to.should == [@apartment.user.email]
    end

    it "sets the subject appropriately" do
      @email.subject.should == "One of your apartments has been unpublished on Cozily..."
    end

    it "includes the user's first name" do
      @email.body.should include("Hello #{@apartment.user.first_name}")
    end
  end
end