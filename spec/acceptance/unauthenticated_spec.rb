require File.dirname(__FILE__) + '/acceptance_helper'

feature "unauthenticated" do
  fixtures :all

  scenario "unauthenticated user browses apartments" do
    apartment = Factory(:published_apartment)

    visit browse_path
    current_path.should == browse_path
    page.should have_content(apartment.street)

    click_link(apartment.street)
    current_path.should == apartment_path(apartment)
    page.should have_content(apartment.address.street)

    neighborhood = apartment.neighborhoods.first
    click_link(neighborhood.name)
    current_path.should == neighborhood_path(neighborhood)
    page.should have_content(neighborhood.name)
  end

  scenario "user can sign in on the homepage" do
    user = Factory(:user)
    visit root_path

    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => user.password
    click_button "Sign in"

    page.should have_content "Hi #{user.first_name}"
  end
end
