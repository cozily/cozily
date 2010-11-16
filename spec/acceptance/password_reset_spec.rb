require File.dirname(__FILE__) + '/acceptance_helper'

feature "password reset" do
  scenario "user is not signed up" do
    User.find_by_email("email@person.com").should be_nil
    visit sign_in_path
    click_link "Forgot password?"
    fill_in "Email address", :with => "email@person.com"
    click_button "Reset password"
    page.should have_content "Unknown email"
  end

  scenario "user is signed up and requests password reset" do
    user = Factory(:user)
    visit sign_in_path
    click_link "Forgot password?"
    fill_in "Email address", :with => user.email
    click_button "Reset password"
    page.should have_content "instructions for changing your password"

    assert !user.confirmation_token.blank?
    assert !ActionMailer::Base.deliveries.empty?
    
    result = ActionMailer::Base.deliveries.any? do |email|
      email.to == [user.email] &&
              email.subject =~ /password/i &&
              email.body =~ /#{user.confirmation_token}/
    end
    assert result
  end

  scenario "user is signed up updated his password and types wrong confirmation" do
    user = Factory(:user)
    visit edit_user_password_path(:user_id => user, :token => user.confirmation_token)
    fill_in "Choose password", :with => "newpassword"
    fill_in "Confirm password", :with => "wrongconfirmation"
    click_button "Save this password"
    page.should have_content("error")
    page.should have_content("Sign in")
  end

  scenario "user is signed up and updates his password" do
    user = Factory(:user)
    visit edit_user_password_path(:user_id => user, :token => user.confirmation_token)
    fill_in "Choose password", :with => "newpassword"
    fill_in "Confirm password", :with => "newpassword"
    click_button "Save this password"

    page.should have_content("Sign out")
    visit sign_out_path
    page.should have_content("Sign in")

    click_link "Sign in"
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "newpassword"
    click_button "Sign in"

    page.should have_content("Sign out")
  end
end
