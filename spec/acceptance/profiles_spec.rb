require File.dirname(__FILE__) + '/acceptance_helper'

feature "profiles" do
  scenario "user creates a profile" do
    user = Factory(:user)
    login_as(user)

    visit edit_profile_path
    check "role_ids_0"
    check "Receive email notifications about new matches"
    check "Receive weekly summary emails about your matches"

    select "2", :from => "Minimum bedrooms"
    fill_in "Maximum rent", :with => "2000"
  #  fill_in "Neighborhoods", :with => neighborhood.name
    select "include them", :from => "Sublets?"

    check "role_ids_1"
    fill_in "Phone", :with => "202-270-7370"
    check "Receive weekly summary emails about your listings"

    click_button "Update Profile"
    user.profile.should_not be_nil
    user.profile.bedrooms.should == 2
    user.profile.rent.should == 2000
    user.profile.sublets.should == Profile::SUBLETS["include them"]
  #  the.user.profile.neighborhoods.should == [Apartment.last.neighborhoods.first]
  end
end
