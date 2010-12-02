require File.dirname(__FILE__) + '/acceptance_helper'

feature "apartments" do
  context "as a lister" do
    before do
      @user = Factory(:lister)
      login_as(@user)
    end

    scenario "user creates an apartment", :js => true do
      visit dashboard_listings_path

      lambda {
        click_link "Create one"
      }.should change(Apartment, :count).by(1)
      apartment = Apartment.last

      current_path.should == edit_apartment_path(apartment)

      fill_in "Address", :with => "546 Henry St 11231"
      fill_in "Unit", :with => "1C"
      fill_in "Rent", :with => "1500"
      fill_in "Bedrooms", :with => "1"
      fill_in "Bathrooms", :with => "1"
      fill_in "Square footage", :with => "500"
      fill_in "Start date", :with => Date.today

      check "backyard"
      check "balcony"

      page.should have_css("li.hidden label:contains('End date')")
      click_link "Save Changes"

      apartment.reload
      current_path.should == edit_apartment_path(apartment)
      ["Carroll Gardens", "backyard", "balcony"].each do |content|
        page.should have_content(content)
      end
    end

    scenario "user creates a sublet", :js => true do
      visit dashboard_listings_path

      lambda {
        click_link "Create one"
      }.should change(Apartment, :count).by(1)
      apartment = Apartment.last

      current_path.should == edit_apartment_path(apartment)

      fill_in "Address", :with => "546 Henry St 11231"
      fill_in "Unit", :with => "1C"
      fill_in "Rent", :with => "1500"
      fill_in "Bedrooms", :with => "1"
      fill_in "Bathrooms", :with => "1"
      fill_in "Square footage", :with => "500"
      fill_in "Start date", :with => Date.today

      check "backyard"
      check "balcony"
      choose "apartment_sublet_true"
      fill_in "End date", :with => 6.months.from_now
      click_link "Save Changes"

      apartment.reload
      current_path.should == edit_apartment_path(apartment)
      ["Carroll Gardens", "backyard", "balcony"].each do |content|
        page.should have_content(content)
      end
    end

    scenario "user edits an apartment" do
      apartment = Factory(:apartment, :user => @user)
      visit apartment_path(apartment)

      click_link "Edit Listing"
      current_path.should == edit_apartment_path(apartment)

      fill_in "Rent", :with => 1000
      click_link "Save Changes"

      current_path.should == edit_apartment_path(Apartment.last)
    end

    scenario "user deletes an apartment" do
      apartment = Factory(:apartment, :user => @user)
      visit edit_apartment_path(apartment)

      click_link "Delete Apartment"
      current_path.should == dashboard_listings_path
    end

    scenario "user publishes an apartment" do
      apartment = Factory(:publishable_apartment, :user => @user)

      visit edit_apartment_path(apartment)
      click_link "Publish Apartment"

      apartment.reload.should be_published
      page.should_not have_css("input[type='submit'][value='publish']")

      current_path.should == apartment_path(apartment)
    end

    scenario "user unpublishes an apartment" do
      apartment = Factory(:published_apartment, :user => @user)

      visit edit_apartment_path(apartment)
      click_link "Unpublish Apartment"

      apartment.reload.should be_unpublished
      page.should_not have_css("input[type='submit'][value='unpublish']")

      current_path.should == edit_apartment_path(apartment)
    end

    scenario "owner views their apartments" do
      3.times { Factory(:apartment, :user => @user) }

      visit "/"
      current_path.should == dashboard_listings_path

      @user.apartments.each do |apartment|
        page.should have_content(apartment.street)
      end
    end
  end

  context "as a finder" do
    before do
      @user = Factory(:user)
      login_as(@user)
    end

    scenario "user views an apartment" do
      apartment = Factory(:published_apartment)
      visit apartment_path(apartment)

      [:full_address,
       :rent,
       :bedrooms,
       :bathrooms,
       :square_footage].each do |attr|
        page.should have_content(apartment.send(attr).to_s)
      end

      visit apartment_path(Factory(:apartment))
      page.should have_content("this apartment is unpublished")
    end
  end
end
