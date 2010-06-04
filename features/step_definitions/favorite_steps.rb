Then /^I can favorite the apartment$/ do
  apartment = Apartment.last
  visit apartment_path(apartment)

  page.should_not have_css("a:contains('unfavorite')")
  lambda {
    click_link "favorite"
  }.should change(Favorite, :count).by(1)

  lambda {
    click_link "unfavorite"
  }.should change(Favorite, :count).by(-1)
end
