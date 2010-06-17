require 'spec_helper'

describe Apartment do
  it { should belong_to(:address) }
  it { should belong_to(:contact) }
  it { should belong_to(:user) }

  it { should have_many(:apartment_features, :dependent => :destroy) }
  it { should have_many(:favorites, :dependent => :destroy) }
  it { should have_many(:features, :through => :apartment_features) }
  it { should have_many(:images, :dependent => :destroy) }

  it { should validate_presence_of(:user) }

  [:rent, :square_footage].each do |attr|
    it { should validate_numericality_of(attr, :allow_nil => true, :greater_than => 0, :only_integer => true) }
  end

  [:bedrooms, :bathrooms].each do |attr|
    it { should validate_numericality_of(attr, :allow_nil => true) }
  end

  it "should validate the uniqueness of the name scoped to the user" do
    @apartment1 = Factory(:apartment)
    @apartment2 = Factory.build(:apartment,
                                :address => @apartment1.address,
                                :unit => @apartment1.unit,
                                :user => @apartment1.user)
    @apartment2.should be_invalid
  end

  describe "#before_save" do
    it "upcases unit" do
      @apartment = Factory(:apartment,
                           :unit => "1c")
      @apartment.reload.unit.should == "1C"
    end

    it "deletes pounds from unit" do
      @apartment = Factory(:apartment,
                           :unit => "#1c")
      @apartment.reload.unit.should == "1C"
    end
  end

  describe "#name" do
    it "should join address and unit" do
      @apartment = Factory(:apartment)
      @apartment.name.should == [@apartment.full_address, @apartment.unit].compact.join(" #")
    end
  end

  describe "#publishable?" do
    before do
      @apartment = Factory(:apartment,
                           :address => Factory.build(:address),
                           :user => Factory.build(:user),
                           :contact => Factory.build(:contact),
                           :rent => 1500,
                           :bedrooms => 1,
                           :bathrooms => 1,
                           :square_footage => 500)
    end

    it "returns true when required fields are present" do
      @apartment.should be_publishable
    end

    [:address, :contact, :user, :rent, :bedrooms, :bathrooms, :square_footage].each do |attr|
      it "returns false when #{attr} is missing" do
        @apartment.send("#{attr}=", nil)
        @apartment.should_not be_publishable
      end
    end
  end
end
