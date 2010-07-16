require 'spec_helper'

describe Favorite do
  before do
    Factory(:favorite)
  end

  it { should belong_to(:user) }
  it { should belong_to(:apartment) }

  it { should validate_uniqueness_of(:apartment_id, :scope => :user_id)}

  it "should ensure that the favoriter is not the owner of the apartment" do
    apartment = Factory(:apartment)
    favorite = Factory.build(:favorite,
                             :apartment => apartment,
                             :user => apartment.user)
    favorite.should be_invalid
    favorite.should have(1).error_on(:user)
  end

  describe "#after_create" do
    it "creates a created TimelineEvent" do
      favorite = Factory.build(:favorite)
      lambda {
        favorite.save
      }.should change(TimelineEvent, :count).by(1)

      event = TimelineEvent.first
      event.event_type.should == "created"
      event.subject == favorite
      event.secondary_subject.should == favorite.apartment
      event.actor.should == favorite.user
    end
  end

  describe "#after_destroy" do
    it "creates a created TimelineEvent" do
      favorite = Factory(:favorite)
      lambda {
        favorite.destroy
      }.should change(TimelineEvent, :count).by(1)

      event = TimelineEvent.first
      event.event_type.should == "destroyed"
      event.subject == favorite
      event.secondary_subject.should == favorite.apartment
      event.actor.should == favorite.user
    end
  end
end
