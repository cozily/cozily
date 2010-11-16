require File.dirname(__FILE__) + '/acceptance_helper'

feature "profiles" do
  scenario "user creates a profile" do
    user = Factory(:user)
    login_as(user)

#    neighborhood = Apartment.last.neighborhoods.first

    visit edit_user_profile_path(user)
    check "role_ids_0"
    check "Receive email notifications about new matches"
    check "Receive weekly summary emails about your matches"

    select "2", :from => "Minimum bedrooms"
    fill_in "Maximum rent", :with => "2000.00"
  #  fill_in "Neighborhoods", :with => neighborhood.name

    check "role_ids_1"
    fill_in "Phone", :with => "202-270-7370"
    check "Receive weekly summary emails about your listings"

    click_button "Update Profile"
    user.profile.should_not be_nil
    user.profile.bedrooms.should == 2.0
    user.profile.rent.should == 2000.00
  #  the.user.profile.neighborhoods.should == [Apartment.last.neighborhoods.first]
  end
end
