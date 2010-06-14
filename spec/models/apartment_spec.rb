require 'spec_helper'

describe Apartment do
  it { should belong_to(:address) }
  it { should belong_to(:contact) }
  it { should belong_to(:user) }

  it { should have_many(:apartment_features, :dependent => :destroy) }
  it { should have_many(:favorites, :dependent => :destroy) }
  it { should have_many(:features, :through => :apartment_features) }

  [:address, :user].each do |attr|
    it { should validate_presence_of(attr) }
  end

  [:rent, :square_footage].each do |attr|
    it { should validate_numericality_of(attr, :allow_nil => true, :greater_than => 0, :only_integer => true) }
  end

  [:bedrooms, :bathrooms].each do |attr|
    it { should validate_numericality_of(attr, :allow_nil => true) }
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
