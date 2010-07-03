require 'spec_helper'

describe Favorite do
  before do
    Factory(:favorite)
  end

  [:user, :apartment].each do |assoc|
    it { should belong_to(assoc) }
    it { should validate_presence_of(assoc) }
  end

  it { should validate_uniqueness_of(:apartment_id, :scope => :user_id)}

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
