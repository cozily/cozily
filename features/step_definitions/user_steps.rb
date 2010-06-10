Given /^I am a logged in user$/ do
  Given %{I am signed up and confirmed as "email@person.com/password"}
  When %Q{I go to the sign in page}
  And %Q{I sign in as "email@person.com/password"}
  Then %Q{I should see "Signed in"}
  And %Q{I should be signed in}
end

Given /^I am not a logged in user$/ do
  visit sign_out_path
  current_path.should == sign_in_path
end