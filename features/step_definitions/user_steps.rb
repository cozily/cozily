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

  click_link "Edit profile"
  current_path.should == edit_user_path(the.user)

  fill_in "Email", :with => "new@email.com"
  click_button "Update Profile"

  the.user.reload.email.should == "new@email.com"
end
