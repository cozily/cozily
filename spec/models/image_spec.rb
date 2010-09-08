require 'spec_helper'

describe Image do
  it { should belong_to(:apartment, :counter_cache => true) }
  it { should validate_presence_of(:apartment) }

  describe "validations" do
    it "should not change Image.count if it's destroyed and it's the only image for a listed apartment" do
      apartment = Factory(:apartment, :state => 'listed')
      image = Factory(:image, :apartment => apartment)

      lambda {
        image.destroy
      }.should_not change(Image, :count)
    end
  end
end
