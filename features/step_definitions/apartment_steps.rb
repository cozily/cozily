Then /^I can create an apartment$/ do
  Given %Q{all the features are present}

  click_link "new apartment"
  current_path.should == new_apartment_path

  When %Q{I fill in an apartment's fields}
  lambda {
    click_button "Create Apartment"
  }.should change(Apartment, :count).by(1)

  current_path.should == apartment_path(Apartment.last)
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

  click_link "edit apartment"
  current_path.should == edit_apartment_path(apartment)

  When %Q{I fill in an apartment's fields}
  click_button "Update Apartment"

  current_path.should == apartment_path(apartment)
end

When /^I fill in an apartment's fields$/ do
  fill_in "Address", :with => "546 Henry St 11231"
  fill_in "Rent", :with => "1500"
  fill_in "Bedrooms", :with => "1"
  fill_in "Bathrooms", :with => "1"
  fill_in "Square footage", :with => "500"

  check "backyard"
  check "balcony"
end

Then /^I can delete the apartment$/ do
  apartment = Apartment.last
  visit edit_apartment_path(apartment)
  click_link "delete this apartment"
  lambda { apartment.reload }.should raise_error(ActiveRecord::RecordNotFound)
end

Then /^I can (publish|unpublish) the apartment$/ do |action|
  apartment = Apartment.last

  visit apartment_path(apartment)
  click_button action

  apartment.reload.send("#{action}ed?").should be_true
  page.should_not have_css("input[type='submit'][value='#{action}']")
end

But /^I cannot (publish|unpublish) another user's apartment$/ do |action|
  visit apartment_path(Factory(:apartment,
                               :state => action == "publish" ? "unpublished" : "published"))

  page.should_not have_css("input[type='submit'][value='#{action}']")
end

Given /^all the features are present$/ do
  ["backyard",
   "balcony"].each do |name|
    Feature.create(:name => name)
  end
end

Given /^I have an? ?(published|unpublished)? apartment$/ do |state|
  Factory(:apartment,
          :user => the.user,
          :state => state || "unpublished")

  the.user.apartments.should be_present
end

Then /^I cannot edit another user's apartment$/ do
  apartment = Factory(:apartment)

  visit apartment_path(apartment)
  page.should_not have_content("edit apartment")

  visit edit_apartment_path(apartment)
  current_path.should == "/"
end

Then /^I can view my apartments$/ do
  visit "/"
  click_link "my apartments"
  current_path.should == user_apartments_path(the.user)

  the.user.apartments.each do |apartment|
    page.should have_content(apartment.full_address)
  end
end
