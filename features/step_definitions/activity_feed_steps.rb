Then /^my activity feed should include apartments that were recently listed$/ do
  apartment = Factory(:apartment)
  apartment.list!

  visit "/"

  page.should have_content("#{apartment.user.first_name} listed a #{apartment.bedrooms.prettify} bedroom apartment in #{apartment.neighborhoods.map(&:name).join(", ")}")
end