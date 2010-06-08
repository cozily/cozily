Then /^I can create an apartment$/ do
  click_link "new apartment"
  current_path.should == new_apartment_path

  When %Q{I fill in an apartment's fields}
  lambda {
    click_button "Create Apartment"
  }.should change(Apartment, :count).by(1)

  current_path.should == apartment_path(Apartment.last)
  page.should have_content "Carroll Gardens"
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