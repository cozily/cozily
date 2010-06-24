require 'spec_helper'

describe Message do
  [:apartment, :sender, :receiver].each do |attr|
    it { should belong_to(attr) }
  end

  [:apartment, :body, :sender, :receiver].each do |attr|
    it { should validate_presence_of(attr) }
  end

  it "should validate that the sender is not the receiver" do
    user = Factory(:user)
    message = Factory.build(:message,
                            :sender => user,
                            :receiver => user)
    message.should be_invalid
  end

  it "should e-mail the receiver after create" do
    message = Factory.build(:message)
    MessageMailer.should_receive(:deliver_receiver_notification).with(message)
    message.save
  end
end
