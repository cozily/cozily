Then /^I can create an? (apartment|sublet)$/ do |apartment_or_sublet|
  Given %Q{all the features are present}

  lambda {
    click_link "New Listing"
  }.should change(Apartment, :count).by(1)
  apartment = Apartment.last

  current_path.should == edit_apartment_path(apartment)

  When %Q{I fill in an apartment's fields}
  if apartment_or_sublet == "sublet"
    choose "apartment_sublet_true"
    fill_in "End date", :with => 6.months.from_now
  else
    page.should have_css("li.hidden label:contains('End date')")
  end
  click_link "Save Changes"

  apartment.reload
  current_path.should == edit_apartment_path(apartment)
  page.should have_content "Carroll Gardens"
  page.should have_content "backyard"
  page.should have_content "balcony"
end

Then /^I cannot create an apartment$/ do
  visit "/"
  page.should_not have_css("a:contains('new apartment')")

  visit new_apartment_path
  current_path.should == "/"
end

Then /^I can view the apartment$/ do
  apartment = Apartment.last
  visit apartment_path(apartment)

  [:full_address,
   :rent,
   :bedrooms,
   :bathrooms,
   :square_footage].each do |attr|
    page.should have_content(apartment.send(attr).to_s)
  end
end

Then /^I can edit the apartment$/ do
  Given %Q{all the features are present}

  apartment = Apartment.last
  visit apartment_path(apartment)

  click_link "Edit Listing"
  current_path.should == edit_apartment_path(apartment)

  When %Q{I fill in an apartment's fields}
  click_link "Save Changes"

  current_path.should == edit_apartment_path(Apartment.last)
end

When /^I fill in an apartment's fields$/ do
  fill_in "Address", :with => "546 Henry St 11231"
  fill_in "Unit", :with => "1C"
  fill_in "Rent", :with => "1500"
  fill_in "Bedrooms", :with => "1"
  fill_in "Bathrooms", :with => "1"
  fill_in "Square footage", :with => "500"
  fill_in "Start date", :with => Date.today

  check "backyard"
  check "balcony"
end

Then /^I can delete the apartment$/ do
  apartment = Apartment.last
  visit edit_apartment_path(apartment)
  click_link "Delete Apartment"
  lambda { apartment.reload }.should raise_error(ActiveRecord::RecordNotFound)
  current_path.should == dashboard_listings_path
end

Then /^I can (list|unlist) the apartment$/ do |action|
  apartment = Apartment.last

  visit edit_apartment_path(apartment)
  click_link "#{action.titleize} Apartment"

  apartment.reload.send("#{action}ed?").should be_true
  page.should_not have_css("input[type='submit'][value='#{action}']")
end

But /^I cannot (list|unlist) another user's apartment$/ do |action|
  visit apartment_path(Factory(:apartment,
                               :state => action == "list" ? "unlisted" : "listed"))

  page.should_not have_css("input[type='submit'][value='#{action}']")
end

Given /^all the features are present$/ do
  ["backyard",
   "balcony"].each do |name|
    Feature.create(:name => name)
  end
end

Given /^I have an? ?(listed|unlisted)? apartment$/ do |state|
  the.user.update_attribute(:phone, "800-555-1212")
  the.apartment = Factory(:apartment,
                          :user => the.user,
                          :images_count => 2,
                          :state => state || "unlisted")
  the.user.apartments(true).should be_present
end

Then /^I cannot edit another user's apartment$/ do
  apartment = Factory(:apartment)

  visit apartment_path(apartment)
  page.should_not have_content("edit apartment")

  visit edit_apartment_path(apartment)
  current_path.should == dashboard_path
end

Then /^I can view my apartments$/ do
  visit "/"
  click_link "my listings"
  current_path.should == dashboard_listings_path

  the.user.apartments.each do |apartment|
    page.should have_content(apartment.street)
  end
end

Then /^I should see that the apartment is unlisted$/ do
  visit apartment_path(Apartment.last)
  page.should have_content("This apartment is unlisted")
end
