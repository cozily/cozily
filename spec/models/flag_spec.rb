require 'spec_helper'

describe Flag do
  before do
    Factory(:flag)
  end

  it { should belong_to(:apartment, :counter_cache => true) }
  it { should belong_to(:user) }

  it { should validate_uniqueness_of(:apartment_id, :scope => :user_id) }

  it "should ensure that the flagger is not the owner of the apartment" do
    apartment = Factory(:apartment)
    flag = Factory.build(:flag,
                         :apartment => apartment,
                         :user => apartment.user)
    flag.should be_invalid
    flag.should have(1).error_on(:user)
  end

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

    it "transitions the apartment to flagged when there are at least #{Flag::THRESHOLD} flags" do
      apartment = Factory(:published_apartment)
      (Flag::THRESHOLD - 1).times { Factory(:flag, :apartment => apartment) }
      flag = Factory.build(:flag, :apartment => apartment)

      lambda {
        flag.save
      }.should change { apartment.state }.from('published').to('flagged')
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
