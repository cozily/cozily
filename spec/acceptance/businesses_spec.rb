require File.dirname(__FILE__) + '/acceptance_helper'

feature "businesses" do
  scenario "user sees nearby restaurants", :js => true do
    login_as(Factory(:user))
    visit apartment_path(Factory(:published_apartment))
    page.should have_css("div#nearby_restaurants ul li.business")
  end
end
