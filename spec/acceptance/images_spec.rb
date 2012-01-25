require File.dirname(__FILE__) + '/acceptance_helper'

feature "photos" do
  scenario "user deletes a photo" do
    user = Factory(:user)
    login_as(user)

    apartment = Factory(:published_apartment, :user => user)
    Factory(:photo, :apartment => apartment)

    visit edit_apartment_path(apartment)
    lambda {
      click_link "Remove"
    }.should change(apartment.photos, :count).by(-1)
  end
end
