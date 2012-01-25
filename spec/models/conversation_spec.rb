require 'spec_helper'

describe Conversation do
  [:apartment, :sender, :receiver].each do |attr|
    it { should belong_to(attr) }
  end

  it { should have_many(:messages, :order => "created_at") }

  [:apartment, :sender, :receiver].each do |attr|
    it { should validate_presence_of(attr) }
  end

  it "should validate that the sender is not the receiver" do
    user = Factory(:user)
    conversation = Factory.build(:conversation,
                            :sender => user,
                            :receiver => user)
    conversation.should be_invalid
  end

  it "should create a message and after it is created" do
    conversation = Factory.build(:conversation)
    lambda { conversation.save }.should change(Message, :count).by(1)
  end

  describe "#the_party_who_is_not" do
    it "should return the user that is not passed in" do
      conversation = Factory.build(:conversation)
      conversation.the_party_who_is_not(conversation.receiver).should == conversation.sender
      conversation.the_party_who_is_not(conversation.sender).should == conversation.receiver
    end
  end

  describe "#unread_message_count_for" do
    it "should return the user's unread messages in the conversation" do
      conversation = Factory(:conversation)
      conversation.unread_message_count_for(conversation.sender).should == 0
      conversation.unread_message_count_for(conversation.receiver).should == 1
    end
  end

  describe "#mark_messages_read_by" do
    it "should mark all of a conversations messages as read by the given user" do
      conversation = Factory(:conversation)
      message = Factory(:message, :sender => conversation.receiver, :conversation => conversation)

      conversation.messages.reload.count.should == 2
      conversation.unread_message_count_for(conversation.sender).should == 1
      conversation.unread_message_count_for(conversation.receiver).should == 1

      conversation.mark_messages_as_read_by(conversation.sender)
      conversation.unread_message_count_for(conversation.sender).should == 0
      conversation.unread_message_count_for(conversation.receiver).should == 1
    end
  end
end
