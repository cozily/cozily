Then /^I can view restaurants that are near the apartment$/ do
  visit apartment_path(Apartment.last)
  page.should have_css("div#nearby_restaurants ul li.business")
end
