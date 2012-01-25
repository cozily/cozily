require File.dirname(__FILE__) + '/acceptance_helper'

feature "password reset" do
  scenario "user is not signed up" do
    User.find_by_email("email@person.com").should be_nil
    visit new_user_session_path
    click_link "Forgot password?"
    fill_in "Email address", :with => "email@person.com"
    click_button "Send Reset Instructions"
    page.should have_content "not found"
  end

  scenario "user is signed up and requests password reset" do
    user = Factory(:user)
    visit new_user_session_path
    click_link "Forgot password?"
    fill_in "Email address", :with => user.email
    click_button "Send Reset Instructions"
    page.should have_content "You will receive an email with instructions"

    assert !user.reload.reset_password_token.blank?
    assert !ActionMailer::Base.deliveries.empty?

    result = ActionMailer::Base.deliveries.any? do |email|
      email.to == [user.email] &&
              email.subject =~ /password/i &&
              email.body =~ /#{user.reload.reset_password_token}/
    end
    assert result
  end

  scenario "user is signed up updated his password and types wrong confirmation" do
    user = Factory(:user, :reset_password_token => "resetme123", :reset_password_sent_at => Time.now)
    visit edit_user_password_path(:user_id => user, :reset_password_token => user.reset_password_token)
    fill_in "Choose password", :with => "newpassword"
    fill_in "Confirm password", :with => "wrongconfirmation"
    click_button "Change my password"
    page.should have_content("error")
    page.should have_content("Sign in")
  end

  scenario "user is signed up and updates his password", js: true do
    user = Factory(:user, :reset_password_token => "resetme123", :reset_password_sent_at => Time.now)
    visit edit_user_password_path(:user_id => user, :reset_password_token => user.reset_password_token)
    fill_in "Choose password", :with => "newpassword"
    fill_in "Confirm password", :with => "newpassword"
    click_button "Change my password"

    page.should have_content("Sign out")
    visit destroy_user_session_path
    page.should have_content("Sign in")

    click_link "Sign in"
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "newpassword"
    click_button "Sign in"

    page.should have_content("Sign out")
  end
end
