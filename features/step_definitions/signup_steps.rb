Then /^I can sign up as an apartment seeker$/ do
  page.find("a img.find").click
  select '1', :from => 'How many bedrooms do you need?'
  fill_in 'How much can you pay?', :with => '1500'

  click_button 'Next'

  fill_in 'First name', :with => first_name = Faker::Name.first_name
  fill_in 'Last name', :with => Faker::Name.last_name
  fill_in 'Email', :with => Faker::Internet.email
  fill_in 'Password', :with => 'pass'
  fill_in 'Confirm password', :with => 'pass'

  click_button 'Sign Up & Start Browsing'

  page.should have_content("Hi #{first_name}")
  page.should have_content("Sign out")

  page.should have_content("Matches")
  page.should have_content("Favorites")
  page.should_not have_content("My Listings")
end

Then /^I can sign up as an apartment lister$/ do
  page.find("a img.list").click
  fill_in 'Email', :with => Faker::Internet.email
  fill_in 'Phone', :with => "800-555-1212"

  click_button 'Next'

  fill_in 'First name', :with => first_name = Faker::Name.first_name
  fill_in 'Last name', :with => Faker::Name.last_name
  fill_in 'Password', :with => 'pass'
  fill_in 'Confirm password', :with => 'pass'

  click_button 'Sign Up & Start Listing'

  page.should have_content("Hi #{first_name}")
  page.should have_content("Sign out")

  page.should have_content("My Listings")
  page.should_not have_content("Matches")
  page.should_not have_content("Favorites")
end