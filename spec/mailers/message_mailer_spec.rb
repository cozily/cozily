require 'spec_helper'

describe MessageMailer do
  describe "#deliver_receiver_notification" do
    before do
      @message = Factory(:message)
    end

    it "queues the email" do
      MessageMailer.deliver_receiver_notification(@message)
      ActionMailer::Base.deliveries.should_not be_empty
    end

    it "sets the recipients appropriately" do
      match_email = MessageMailer.deliver_receiver_notification(@message)
      match_email.to.should == [@message.receiver.email]
    end

    it "sets the subject appropriately" do
      match_email = MessageMailer.deliver_receiver_notification(@message)
      match_email.subject.should == "#{@message.sender.full_name} sent you a message on Cozily..."
    end

    it "includes the user's first name" do
      match_email = MessageMailer.deliver_receiver_notification(@message)
      match_email.body.should include("Hello #{@message.receiver.first_name}")
    end

    it "includes the message's body" do
      match_email = MessageMailer.deliver_receiver_notification(@message)
      match_email.body.should include(@message.body)
    end
  end
end
