require 'spec_helper'

describe Apartment do
  it { should belong_to(:address) }
  it { should belong_to(:user) }

  it { should have_many(:apartment_features, :dependent => :destroy) }
  it { should have_many(:favorites, :dependent => :destroy) }
  it { should have_many(:features, :through => :apartment_features) }
  it { should have_many(:flags, :dependent => :destroy) }
  it { should have_many(:images, :order => "position", :dependent => :destroy) }
  it { should have_many(:conversations, :dependent => :destroy) }

  it { should validate_presence_of(:user) }

  [:rent, :square_footage].each do |attr|
    it { should validate_numericality_of(attr, :allow_nil => true, :greater_than => 0, :only_integer => true) }
  end

  [:bedrooms, :bathrooms].each do |attr|
    it { should validate_numericality_of(attr, :allow_nil => true) }
  end

  it "should validate the uniqueness of the address scoped to the user and unit" do
    @apartment1 = Factory(:apartment)
    @apartment2 = Factory.build(:apartment,
                                :address => @apartment1.address,
                                :unit => @apartment1.unit,
                                :user => @apartment1.user)
    @apartment2.should be_invalid
  end

  it "should validate presence of end date if it's a sublet" do
    @apartment = Factory.build(:apartment,
                               :sublet => true,
                               :end_date => nil)
    @apartment.should_not be_valid
    @apartment.should have(1).error_on(:end_date)
  end

  describe ".bedrooms_near" do
    it "returns apartments with bedrooms within 0.5 of the given value" do
      @apartment1 = Factory(:apartment, :bedrooms => 2)
      @apartment2 = Factory(:apartment, :bedrooms => 3)
      @apartment3 = Factory(:apartment, :bedrooms => 4)

      Apartment.bedrooms_near(2.5).should include(@apartment1)
      Apartment.bedrooms_near(2.5).should include(@apartment2)
      Apartment.bedrooms_near(2.5).should_not include(@apartment3)
    end
  end

  describe ".rent_near" do
    it "returns apartments with rent within 20% of the given value" do
      @apartment1 = Factory(:apartment, :rent => 800)
      @apartment2 = Factory(:apartment, :rent => 1200)
      @apartment3 = Factory(:apartment, :rent => 1201)

      Apartment.rent_near(1000).should include(@apartment1)
      Apartment.rent_near(1000).should include(@apartment2)
      Apartment.rent_near(1000).should_not include(@apartment3)
    end
  end

  describe "#after_update" do
    ['unlisted', 'listed'].each do |state|
      it "creates a status_changed_to_#{state} TimelineEvent when the state has changed" do
        initial_state = case state
          when 'unlisted' then
            'listed'
          when 'listed' then
            'unlisted'
        end

        apartment = Factory(:apartment, :state => initial_state)

        lambda {
          apartment.state = state
          apartment.save!
        }.should change(TimelineEvent, :count).by(1)

        event = TimelineEvent.last
        event.event_type.should == "state_changed_to_#{state}"
        event.subject.should == apartment
        event.actor.should == apartment.user
      end
    end

    it "does not create a status_changed TimelineEvent when the state has not changed" do
      apartment = Factory(:apartment)

      lambda {
        apartment.touch
      }.should_not change(TimelineEvent, :count)
    end
  end

  describe "#before_validation" do
    it "upcases unit" do
      @apartment = Factory.build(:apartment, :unit => "1c")
      @apartment.save
      @apartment.reload.unit.should == "1C"
    end

    it "deletes pounds from unit" do
      @apartment = Factory.build(:apartment, :unit => "#1c")
      @apartment.save
      @apartment.reload.unit.should == "1C"
    end
  end

  describe "#last_state_change" do
    before do
      @apartment = Factory(:apartment)
    end

    it "returns the last state change" do
      state_change1 = Factory(:timeline_event,
                              :subject => @apartment,
                              :event_type => "state_changed_to_listed",
                              :created_at => 5.days.ago)
      Factory(:timeline_event,
              :subject => @apartment,
              :event_type => "state_changed_to_unlisted",
              :created_at => 10.days.ago)
      Factory(:timeline_event,
              :subject => @apartment,
              :event_type => "deleted",
              :created_at => 1.day.ago)

      @apartment.last_state_change.should == state_change1
    end

    it "returns nil when there are no state changes" do
      @apartment.last_state_change.should be_nil
    end
  end

  describe "#listable?" do
    before do
      @user = Factory(:email_confirmed_user,
                      :phone => "800-555-1212")
      @apartment = Factory(:apartment,
                           :address => Factory.build(:address),
                           :user => @user,
                           :rent => 1500,
                           :bedrooms => 1,
                           :bathrooms => 1,
                           :square_footage => 500,
                           :images_count => 2)
    end

    it "returns true when required fields are present" do
      @apartment.should be_listable
    end

    it "returns true when the apartment is a sublet" do
      @apartment.update_attribute(:sublet, :true)
      @apartment.should be_listable
    end

    [:address, :user, :rent, :bedrooms, :bathrooms, :square_footage].each do |attr|
      it "returns false when #{attr} is missing" do
        @apartment.send("#{attr}=", nil)
        @apartment.should_not be_listable
      end
    end

    it "returns false when there are fewer than two images" do
      @apartment.update_attribute(:images_count, 1)
      @apartment.should_not be_listable
    end

    it "returns false when a sublet doesn't have an end date" do
      @apartment.update_attributes(:sublet => true, :end_date => nil)
      @apartment.should_not be_listable
    end

    it "returns false when the user doesn't have a phone number" do
      @user.update_attribute(:phone, nil)
      @apartment.should_not be_listable
    end

    it "returns false when the user hasn't confirmed their email" do
      @user.update_attribute(:email_confirmed, false)
      @apartment.should_not be_listable
    end
  end

  describe "#listed_on" do
    before do
      @apartment = Factory(:apartment)
    end

    it "returns the latest date that the apartment was listed" do
      Factory(:timeline_event,
              :subject => @apartment,
              :event_type => "state_changed_to_listed",
              :created_at => date1 = 5.days.ago)
      Factory(:timeline_event,
              :subject => @apartment,
              :event_type => "state_changed_to_listed",
              :created_at => 10.days.ago)

      @apartment.listed_on.should == date1
    end

    it "returns nil if the apartment hasn't been listed" do
      @apartment.listed_on.should be_nil
    end
  end

  describe "#match_for?" do
    before do
      @apartment = Factory(:apartment,
                           :rent => 1800,
                           :bedrooms => 1)
      @user = Factory(:user)
      @profile = Factory(:profile,
                         :user => @user,
                         :bedrooms => 1,
                         :rent => 1800,
                         :neighborhoods => [@apartment.neighborhoods.first])
    end

    it "returns true when the apartment matches the user's profile" do
      @apartment.match_for?(@user).should be_true
    end

    it "returns true when the user hasn't specified rent" do
      @profile.update_attribute(:rent, nil)
      @apartment.match_for?(@user).should be_true
    end

    it "returns true when the user hasn't specified bedrooms" do
      @profile.update_attribute(:bedrooms, nil)
      @apartment.match_for?(@user).should be_true
    end

    it "returns true when the user hasn't specified neighborhoods" do
      @profile.update_attribute(:neighborhoods, [])
      @apartment.match_for?(@user).should be_true
    end

    it "returns false when the apartment does not match the user's rent" do
      @apartment.update_attribute(:rent, 1801)
      @apartment.match_for?(@user).should be_false
    end

    it "returns true when the apartment does not match the user's bedrooms" do
      @apartment.update_attribute(:bedrooms, 0)
      @apartment.match_for?(@user).should be_false
    end

    it "returns true when the apartment matches the user's neighborhoods" do
      @apartment.update_attribute(:address, Factory(:address))
      @apartment.reload.match_for?(@user).should be_false
    end

    it "returns false when the user doesn't have a profile" do
      @profile.destroy
      @apartment.match_for?(@user).should be_false
    end
  end

  describe "#name" do
    it "should join address and unit" do
      @apartment = Factory(:apartment)
      @apartment.name.should == [@apartment.full_address, @apartment.unit].compact.join(" #")
    end
  end
end
