require File.dirname(__FILE__) + '/acceptance_helper'

feature "neighborhoods" do
  scenario "user views apartments by neighborhood" do
    apartment = Factory(:published_apartment)

    visit apartment_path(apartment)
    click_link apartment.neighborhoods.first.name

    current_path.should == neighborhood_path(apartment.neighborhoods.first)
    page.should have_css("a:contains('#{apartment.street}')")
  end

  scenario "user views a neighborhood index page" do
    visit neighborhood_path(Neighborhood.first)

    click_link "see all neighborhoods"

    current_path.should == neighborhoods_path
    Neighborhood.all.each do |neighborhood|
      page.should have_content(neighborhood.name)
    end
  end

  scenario "user adds and removes a neighborhood from their profile", :js => true do
    user = Factory(:user, :profile => Profile.new)
    apartment = Factory(:published_apartment)

    login_as(user)

    neighborhood = apartment.neighborhoods.first
    visit neighborhood_path(neighborhood)

    page.should have_content("in all neighborhoods")
    click_link "add this neighborhood to your profile"
    page.should have_no_content("in all neighborhoods")
    page.should have_content("in #{neighborhood.name}")
    click_link "remove this neighborhood from your profile"
    page.should have_content("in all neighborhoods")
  end
end
