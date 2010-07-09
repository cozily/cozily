Then /^I can create a profile$/ do
  visit edit_user_profile_path(the.user)

  fill_in "Bedrooms", :with => "2"
  fill_in "Rent", :with => "2000.00"

  click_button "Save Profile"
  the.user.profile.should_not be_nil
  the.user.profile.bedrooms.should == 2.0
  the.user.profile.rent.should == 2000.00
end
