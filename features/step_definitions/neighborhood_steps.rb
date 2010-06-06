Then /^I can view the apartment by its neighborhood$/ do
  apartment = Apartment.last

  click_link "neighborhoods"
  click_link apartment.neighborhood.name

  current_path.should == neighborhood_path(apartment.neighborhood)
  page.should have_css("a:contains('#{apartment.full_address}')")
end
