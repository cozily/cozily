require File.dirname(__FILE__) + '/acceptance_helper'

feature "sign in" do
  scenario "user is not signed up" do
    User.find_by_email("email@person.com").should be_nil

    visit sign_in_path
    fill_in "Email", :with => "email@person.com"
    fill_in "Password", :with => "password"
    click_button "Sign in"

    page.should have_content "Bad email or password"
    page.should have_content "Sign in"
  end

  scenario "user is not confirmed" do
    user = Factory(:user)

    visit sign_in_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "password"
    click_button "Sign in"

    page.should have_content "remember to confirm your email address"
    page.should have_content "Sign out"
  end

  scenario "user enters wrong password" do
    user = Factory(:user)

    visit sign_in_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "wrongpassword"
    click_button "Sign in"

    page.should have_content "Bad email or password"
    page.should have_content "Sign in"
  end

  scenario "user signs in successfully" do
    user = Factory(:email_confirmed_user)

    visit sign_in_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "password"
    click_button "Sign in"

    page.should have_content "Signed in"
    page.should have_content "Sign out"

    visit root_path
    page.should have_content "Sign out"
  end
end
