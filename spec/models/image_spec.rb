require 'spec_helper'

describe Image do
  it { should belong_to(:apartment, :counter_cache => true) }
  it { should validate_presence_of(:apartment) }

  describe "validations" do
    it "should not change Image.count if it's destroyed and it's the only image for a published apartment" do
      apartment = Factory(:apartment, :state => 'published')
      image = Factory(:image, :apartment => apartment)

      lambda {
        image.destroy
      }.should_not change(Image, :count)
    end
  end

  describe "#destroyable?" do
    before do
      @apartment = Factory(:apartment, :state => 'published')
      2.times { Factory(:image, :apartment => @apartment) }
    end

    it "returns true if the apartment is published and has more than two images" do
      Factory(:image, :apartment => @apartment)
      @apartment.images.first.should be_destroyable
    end

    it "returns true if the apartment is not published" do
      @apartment.update_attribute(:state, 'unpublished')
      @apartment.images.first.should be_destroyable
    end

    it "returns false if the apartment is published and has fewer than two images" do
      @apartment.images.first.should_not be_destroyable
    end
  end
end
