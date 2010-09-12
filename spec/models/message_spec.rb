require 'spec_helper'

describe Message do
  [:sender, :conversation].each do |attr|
    it { should belong_to(attr) }
  end

  [:body, :sender].each do |attr|
    it { should validate_presence_of(attr) }
  end

  it "should be invalid with the default body" do
    message = Factory.build(:message, :body => Message::DEFAULT_BODY)
    message.should be_invalid
    message.should have(1).error_on(:body)
  end

  it "should e-mail the receiver after create" do
    conversation = Factory.build(:conversation)
    MessageMailer.should_receive(:deliver_receiver_notification)
    conversation.save
  end

  describe "#recipient" do
    it "returns the conversation user who is not the message's recipient" do
      conversation = Factory(:conversation)
      message = conversation.messages.first
      message.receiver.should == conversation.receiver
    end
  end
end
