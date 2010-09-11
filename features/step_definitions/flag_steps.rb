Then /^I can flag the apartment$/ do
  apartment = Apartment.last

  visit apartment_path(apartment)

  page.should have_no_css("a:contains('unflag this')")
  click_link "flag this"
  click_link "unflag this"
  page.should have_no_css("a:contains('unflag this')")
end
