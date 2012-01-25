require File.dirname(__FILE__) + '/acceptance_helper'

feature "sign out" do
  scenario "user signs out" do
    user = Factory(:email_confirmed_user)

    visit new_user_session_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "password"
    click_button "Sign in"

    page.should have_content("Hi #{user.first_name}")
    page.should have_content("Sign out")

    visit destroy_user_session_path
    page.should have_content("Signed out")
    page.should have_content("Sign in")

    visit root_path
    page.should have_content("Sign in")
  end
end
