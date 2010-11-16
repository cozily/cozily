require File.dirname(__FILE__) + '/acceptance_helper'

feature "flags" do
  scenario "user flags an apartment", :js => true do
    login_as(Factory(:user))

    visit apartment_path(Factory(:published_apartment))

    page.should have_no_css("a:contains('unflag this')")
    click_link "flag this"
    click_link "unflag this"
    page.should have_no_css("a:contains('unflag this')")
  end
end