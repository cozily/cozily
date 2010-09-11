Given /^there are searchable apartments$/ do
  Factory.create(:apartment, :bedrooms => 2, :bathrooms => 1, :rent => 2000, :state => 'unlisted')
  Factory.create(:apartment, :bedrooms => 2, :bathrooms => 0.5, :rent => 1700, :state => 'listed')
  Factory.create(:apartment, :bedrooms => 1, :bathrooms => 1, :rent => 1800, :state => 'unlisted')
  Factory.create(:apartment, :bedrooms => 2, :bathrooms => 1, :rent => 2300, :state => 'listed')
end

Given /^I can search for apartments without parameters$/ do
  visit root_path

  click_button "search"
  current_path.should == search_path

  Apartment.with_state(:listed).each do |apartment|
    page.should have_content(apartment.street)
  end
end

Then /^I can search for apartments with parameters$/ do
  visit root_path

  fill_in "q_min_bedrooms", :with => "2"
  fill_in "q_max_rent", :with => "1800"

  page.driver.browser.execute_script("$('input#q_min_bedrooms').blur()");
  page.driver.browser.execute_script("$('input#q_max_rent').blur()");

  sleep 1

  find("#q_min_bedrooms").value.should == "2+ Bedrooms"
  find("#q_max_rent").value.should == "Under $1800"

  click_button "search"
  current_path.should == search_path

  Apartment.with_state(:listed).bedrooms_gte(2).rent_lte(1800).each do |apartment|
    page.should have_content(apartment.street)
  end
end
