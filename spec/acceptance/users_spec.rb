require File.dirname(__FILE__) + '/acceptance_helper'

feature "users" do
  before do
    @user = Factory(:user)
    login_as(@user)
  end

  scenario "user edits their profile" do
    visit root_path

    click_link "My Cozily"

    current_path.should == edit_user_registration_path

    fill_in "Email", :with => "new@email.com"
    click_button "Update Account"

    @user.reload.email.should == "new@email.com"
  end

  scenario "user edits their roles" do
    visit root_path
    page.should have_content("Matches")
    page.should have_no_content("My Listings")

    visit edit_profile_path
    uncheck "role_ids_0"
    check "role_ids_1"
    fill_in "user_phone", :with => "123-456-7890"
    click_button "Update Profile"

    visit root_path
    page.should have_no_content("Matches")
    page.should have_content("My Listings")

    visit edit_profile_path
    check "role_ids_0"
    click_button "Update Profile"

    visit root_path
    page.should have_content("Matches")
    page.should have_content("My Listings")

    visit edit_profile_path
    uncheck "role_ids_0"
    uncheck "role_ids_1"
    click_button "Update Profile"

    page.should have_content("error")
  end
end
