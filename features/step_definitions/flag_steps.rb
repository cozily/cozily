Then /^I can flag the apartment$/ do
  apartment = Apartment.last

  visit apartment_path(apartment)

  page.should_not have_css("a:contains('unflag')")
  lambda {
    click_link "flag"
  }.should change(Flag, :count).by(1)

  lambda {
    click_link "unflag"
  }.should change(Flag, :count).by(-1)  
end
