require 'spec_helper'

describe Conversation do
  [:apartment, :sender, :receiver].each do |attr|
    it { should belong_to(attr) }
  end

  it { should have_many(:messages) }
  
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
end
