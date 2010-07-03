Then /^I can view the apartment by its neighborhood$/ do
  apartment = Apartment.last

  click_link "neighborhoods"
  click_link apartment.neighborhoods.first.name

  current_path.should == neighborhood_path(apartment.neighborhoods.first)
  page.should have_css("a:contains('#{apartment.full_address}')")
end
