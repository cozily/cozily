Then /^I can view restaurants that are near the apartment$/ do
  visit apartment_path(Apartment.last)
  page.should have_content("Lucali")
  page.should have_content("Koto Sushi")
end
