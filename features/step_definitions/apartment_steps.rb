Then /^I can create an? (apartment|sublet)$/ do |apartment_or_sublet|
  Given %Q{all the features are present}

  visit dashboard_listings_path

  lambda {
    click_link "Create one"
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

Then /^I can (publish|unpublish) the apartment$/ do |action|
  apartment = Apartment.last

  visit edit_apartment_path(apartment)
  click_link "#{action.titleize} Apartment"

  apartment.reload.send("#{action}ed?").should be_true
  page.should_not have_css("input[type='submit'][value='#{action}']")

  current_path.should == if action == "publish"
    apartment_path(apartment)
  else
    edit_apartment_path(apartment)
  end
end

But /^I cannot (publish|unpublish) another user's apartment$/ do |action|
  if action == "publish"
    visit apartment_path(Factory(:apartment))
  else
    visit apartment_path(Factory(:published_apartment))
  end

  page.should_not have_css("input[type='submit'][value='#{action}']")
end

Given /^all the features are present$/ do
  ["backyard",
   "balcony"].each do |name|
    Feature.create(:name => name)
  end
end

Given /^I have an? ?(published|unpublished)? apartment$/ do |state|
  the.user.update_attribute(:phone, "800-555-1212")
  the.apartment = Factory(:apartment,
                          :user => the.user,
                          :images_count => 2,
                          :state => state || "unpublished")
  the.user.apartments(true).should be_present
end

Then /^I can view my apartments$/ do
  visit "/"
  current_path.should == dashboard_listings_path

  the.user.apartments.each do |apartment|
    page.should have_content(apartment.street)
  end
end

Then /^I should see that the apartment is unpublished$/ do
  visit apartment_path(Apartment.last)
  page.should have_content("This apartment is unpublished")
end
