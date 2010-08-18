Given /^I am a logged in user$/ do
  Given %{I am signed up and confirmed as "email@person.com/password"}
  When %Q{I go to the sign in page}
  And %Q{I sign in as "email@person.com/password"}
  Then %Q{I should see "Signed in"}
  And %Q{I should be signed in}

  the.user = User.last
end

Given /^I am not a logged in user$/ do
  visit sign_out_path

  current_path.should == sign_in_path
end

Then /^I can edit my profile$/ do
  visit root_path

  click_link "My Cozily"
  current_path.should == edit_user_path(the.user)

  fill_in "Email", :with => "new@email.com"
  click_button "Update Profile"

  the.user.reload.email.should == "new@email.com"
end

Given /^I am an unauthenticated user$/ do
  the.user = Factory(:email_confirmed_user)
end

Then /^I can sign in on the homepage$/ do
  visit root_path

  fill_in "session_email", :with => the.user.email
  fill_in "session_password", :with => the.user.password
  click_button "Sign in"

  page.should have_content "Hi #{the.user.first_name}"
end

Then /^I can edit my roles$/ do
  visit edit_user_path(the.user)

  check "find apartments"
  uncheck "list apartments"
  click_button "Update Profile"

  page.should have_content("Matches")
  page.should_not have_content("My Listings")

  visit edit_user_path(the.user)
  uncheck "find apartments"
  check "list apartments"
  click_button "Update Profile"

  page.should_not have_content("Matches")
  page.should have_content("My Listings")

  visit edit_user_path(the.user)
  check "find apartments"
  check "list apartments"
  click_button "Update Profile"

  page.should have_content("Matches")
  page.should have_content("My Listings")

  visit edit_user_path(the.user)
  uncheck "find apartments"
  uncheck "list apartments"
  click_button "Update Profile"

  page.should have_content("Matches")
  page.should_not have_content("My Listings")
end

