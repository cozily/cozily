require 'spec_helper'

describe Message do
  [:sender, :conversation].each do |attr|
    it { should belong_to(attr) }
  end

  [:body, :sender].each do |attr|
    it { should validate_presence_of(attr) }
  end

  it "should e-mail the receiver after create" do
    conversation = Factory.build(:message)
    lambda {
      conversation.save
    }.should change(ActionMailer::Base.deliveries, :count).by(1)
    ActionMailer::Base.deliveries.last.subject.should =~ /sent you a message on Cozily/
  end

  describe "#recipient" do
    it "returns the conversation user who is not the message's recipient" do
      conversation = Factory(:conversation)
      message = conversation.messages.first
      message.receiver.should == conversation.receiver
    end
  end
end
