require File.dirname(__FILE__) + '/acceptance_helper'

feature "sign up" do
  scenario "user signs up with invalid data" do
    visit sign_up_path
    fill_in "Email", :with => "invalidemail"
    fill_in "Password", :with => "password"
    fill_in "Confirm password", :with => ""
    click_button "Sign up"
    page.should have_content("error")
  end

  scenario "user signs up with valid data" do
    visit sign_up_path
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
    assert !user.confirmation_token.blank?
    Delayed::Job.count.should > 0
    Delayed::Job.last.handler.should =~ /:confirmation/
  end

  scenario "user confirms his account" do
    user = Factory(:user)
    visit new_user_confirmation_path(:user_id => user, :token => user.confirmation_token)
    page.should have_content("Confirmed email and signed in")
    page.should have_content("Sign out")
  end

  scenario "signed in user clicks confirmation link again" do
    user = Factory(:user)
    visit new_user_confirmation_path(:user_id => user, :token => user.confirmation_token)
    page.should have_content("Sign out")

    visit new_user_confirmation_path(:user_id => user, :token => user.confirmation_token)
    page.should have_content("Confirmed email and signed in")
    page.should have_content("Sign out")
  end

  scenario "signed out user clicks confirmation link again" do
    user = Factory(:user)
    visit new_user_confirmation_path(:user_id => user, :token => user.confirmation_token)
    page.should have_content("Sign out")

    visit sign_out_path
    visit new_user_confirmation_path(:user_id => user, :token => user.confirmation_token)
    page.should have_content("Already confirmed email. Please sign in.")
    page.should have_content("Sign in")
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
