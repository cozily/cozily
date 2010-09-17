Then /^I can create a profile$/ do
  neighborhood = Apartment.last.neighborhoods.first

  visit edit_user_profile_path(the.user)
  check "find apartments"
  check "Receive email notifications about new matches"

  select "2", :from => "Minimum bedrooms"
  fill_in "Maximum rent", :with => "2000.00"
#  fill_in "Neighborhoods", :with => neighborhood.name

  click_button "Update Profile"
  the.user.profile.should_not be_nil
  the.user.profile.bedrooms.should == 2.0
  the.user.profile.rent.should == 2000.00
#  the.user.profile.neighborhoods.should == [Apartment.last.neighborhoods.first]
end
