require 'spec_helper'

describe Flag do
  before do
    Factory(:flag)
  end

  it { should belong_to(:apartment, :counter_cache => true) }
  it { should belong_to(:user) }

  it { should validate_uniqueness_of(:apartment_id, :scope => :user_id) }

  describe "#after_create" do
    it "creates a created TimelineEvent" do
      flag = Factory.build(:flag)
      lambda {
        flag.save
      }.should change(TimelineEvent, :count).by(1)

      event = TimelineEvent.first
      event.event_type.should == "created"
      event.subject == flag
      event.secondary_subject.should == flag.apartment
      event.actor.should == flag.user
    end
  end

  describe "#after_destroy" do
    it "creates a created TimelineEvent" do
      flag = Factory(:flag)
      lambda {
        flag.destroy
      }.should change(TimelineEvent, :count).by(1)

      event = TimelineEvent.first
      event.event_type.should == "destroyed"
      event.subject == flag
      event.secondary_subject.should == flag.apartment
      event.actor.should == flag.user
    end
  end
end
