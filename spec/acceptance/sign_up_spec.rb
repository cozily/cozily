require File.dirname(__FILE__) + '/acceptance_helper'

feature "sign up" do
  scenario "user signs up with invalid data" do
    visit new_user_registration_path
    fill_in "Email", :with => "invalidemail"
    fill_in "Password", :with => "password"
    fill_in "Confirm password", :with => ""
    click_button "Sign up"
    page.should have_content("error")
  end

  scenario "user signs up with valid data" do
    visit new_user_registration_path
    fill_in "First name", :with => "Barack"
    fill_in "Last name", :with => "Obama"
    fill_in "Email", :with => "email@person.com"
    fill_in "Password", :with => "password"
    fill_in "Confirm password", :with => "password"
    check "role_ids_0"
    click_button "Sign up"
    page.should have_content "Welcome to Cozily!"
    page.should have_content "Hi Barack"

    user = User.find_by_email("email@person.com")
    user.should_not be_nil
  end

  scenario "apartment seeker signs up", :js => true do
#    When I go to the home page
#    Then I can sign up as an apartment seeker
  end

  scenario "apartment lister signs up", :js => true do
#    When I go to the home page
#    Then I can sign up as an apartment lister
  end
end
