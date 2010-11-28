require File.dirname(__FILE__) + '/acceptance_helper'

feature "neighborhoods" do
  scenario "user views apartments by neighborhood" do
    apartment = Factory(:published_apartment)

    visit apartment_path(apartment)
    click_link apartment.neighborhoods.first.name

    current_path.should == neighborhood_path(apartment.neighborhoods.first)
    page.should have_css("a:contains('#{apartment.street}')")
  end

  scenario "user adds and removes a neighborhood from their profile", :js => true do
    user = Factory(:user, :profile => Profile.new)
#    profile = Factory(:profile, :user => user)
    apartment = Factory(:published_apartment)

    login_as(user)

    neighborhood = apartment.neighborhoods.first
    visit neighborhood_path(neighborhood)

    click_link "add this neighborhood to your profile"
    click_link "remove this neighborhood from your profile"
  end
end
