Given /^the apartment has a photo$/ do
  pending "getting cucumber to work with s3"
  the.image = Factory(:image,
                      :apartment => the.apartment)
end

Then /^I can delete a photo from the apartment$/ do
  visit edit_apartment_path(the.apartment)
  lambda {
    click_link "Remove Photo"
  }.should change(the.apartment.photos, :count).by(-1)
end