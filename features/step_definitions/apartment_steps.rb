Then /^I can create an apartment$/ do
  click_link "new apartment"
  current_path.should == new_apartment_path

  fill_in "Address", :with => "546 Henry St 11231"
  fill_in "Rent", :with => "1500"
  fill_in "Bedrooms", :with => "1"
  fill_in "Bathrooms", :with => "1"
  fill_in "Square footage", :with => "500"
  fill_in "Description", :with => Faker::Lorem.paragraph

  lambda {
    click_button "Create Apartment"
  }.should change(Apartment, :count).by(1)
  current_path.should == apartment_path(Apartment.last)
end

Then /^I can view the apartment$/ do
  apartment = Apartment.last
  visit apartment_path(apartment)

  [:full_address,
   :rent,
   :bedrooms,
   :bathrooms,
   :square_footage,
   :description].each do |attr|
    page.should have_content(apartment.send(attr).to_s)
  end
end