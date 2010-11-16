require File.dirname(__FILE__) + '/acceptance_helper'

feature "images" do
  scenario "user deletes a photo" do
    user = Factory(:user)
    login_as(user)

    apartment = Factory(:published_apartment, :user => user)
    Factory(:image, :apartment => apartment)

    visit edit_apartment_path(apartment)
    lambda {
      click_link "Remove"
    }.should change(apartment.images, :count).by(-1)
  end
end