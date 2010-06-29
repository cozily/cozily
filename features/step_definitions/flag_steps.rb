Then /^I can flag the apartment$/ do
  apartment = Apartment.last

  visit apartment_path(apartment)

  page.should_not have_css("a:contains('unflag this')")
  lambda {
    click_link "flag this"
  }.should change(Flag, :count).by(1)

  lambda {
    click_link "unflag this"
  }.should change(Flag, :count).by(-1)
end
