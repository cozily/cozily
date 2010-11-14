Given /^there are searchable apartments$/ do
  Factory(:apartment, :bedrooms => 2, :bathrooms => 1, :rent => 2000)
  Factory(:published_apartment, :bedrooms => 2, :bathrooms => 0.5, :rent => 1700)
  Factory(:apartment, :bedrooms => 1, :bathrooms => 1, :rent => 1800)
  Factory(:published_apartment, :bedrooms => 2, :bathrooms => 1, :rent => 2300)
end

Given /^I can search for apartments without parameters$/ do
  visit root_path

  click_button "search"
  current_path.should == search_path

  Apartment.with_state(:published).each do |apartment|
    page.should have_content(apartment.street)
  end
end

Then /^I can search for apartments with parameters$/ do
  visit root_path

  fill_in "q_min_bedrooms", :with => "2"
  fill_in "q_max_rent", :with => "1800"

  click_button "search"

  find("#q_min_bedrooms").value.should == "2+ Bedrooms"
  find("#q_max_rent").value.should == "Under $1800"
  current_path.should == search_path

  Apartment.with_state(:published).bedrooms_gte(2).rent_lte(1800).each do |apartment|
    page.should have_content(apartment.street)
  end

  fill_in "neighborhood_autocomplete", :with => "Greenp"
  sleep 1

  page.driver.browser.execute_script(%Q{$("a.ui-corner-all:first").eq(0).mouseenter().click()})
  find("#neighborhood_autocomplete").value.should == "Greenpoint"

  click_button "search"
  current_path.should == search_path

  find("#neighborhood_autocomplete").value.should == "Greenpoint"

  Apartment.with_state(:published).bedrooms_gte(2).rent_lte(1800).each do |apartment|
    next unless apartment.neighborhoods.include?(Neighborhood.find_by_name("Greenpoint"))
    page.should have_content(apartment.street)
  end
end

And /^the session should remember my parameters$/ do
  visit root_path

  find("#neighborhood_autocomplete").value.should == "Greenpoint"
  find("#q_min_bedrooms").value.should == "2+ Bedrooms"
  find("#q_max_rent").value.should == "Under $1800"

  click_button "search"
  current_path.should == search_path

  Apartment.with_state(:published).bedrooms_gte(2).rent_lte(1800).each do |apartment|
    next unless apartment.neighborhoods.include?(Neighborhood.find_by_name("Greenpoint"))
    page.should have_content(apartment.street)
  end
end
