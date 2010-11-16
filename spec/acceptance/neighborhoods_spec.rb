require File.dirname(__FILE__) + '/acceptance_helper'

feature "neighborhoods" do
  scenario "user views apartments by neighborhood" do
    apartment = Factory(:published_apartment)

    visit apartment_path(apartment)
    click_link apartment.neighborhoods.first.name

    current_path.should == neighborhood_path(apartment.neighborhoods.first)
    page.should have_css("a:contains('#{apartment.street}')")
  end
end
