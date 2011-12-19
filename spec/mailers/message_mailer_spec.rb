require 'spec_helper'

describe MessageMailer do
  describe "#deliver_receiver_notification" do
    before do
      @message = Factory(:message)
      @email = MessageMailer.receiver_notification(@message.id).deliver
    end

    it "queues the email" do
      ActionMailer::Base.deliveries.should_not be_empty
    end

    it "sets the recipients appropriately" do
      @email.to.should == [@message.receiver.email]
    end

    it "sets the subject appropriately" do
      @email.subject.should == "#{@message.sender.full_name} sent you a message on Cozily..."
    end

    it "includes the user's first name" do
      @email.body.should include("Hello #{@message.receiver.first_name}")
    end

    it "includes the message's body" do
      @email.body.should include(@message.body)
    end
  end
end
