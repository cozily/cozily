require File.dirname(__FILE__) + '/acceptance_helper'

feature "authorization" do
  fixtures :all

  scenario "unauthenticated user cannot create apartment" do
    visit root_path
    page.should have_no_css("a:contains('new apartment')")

    visit new_apartment_path
    current_path.should == new_user_session_path
  end

  scenario "user cannot edit another user's apartment" do
    login_as(Factory(:user))

    apartment = Factory(:apartment)

    visit apartment_path(apartment)
    page.should_not have_content("edit apartment")

    visit edit_apartment_path(apartment)
    current_path.should == dashboard_matches_path
  end

  scenario "non-admin cannot view admin pages" do
    login_as(Factory(:user))

    [admin_users_path,
     admin_apartments_path].each do |path|
      visit path

      current_path.should == dashboard_matches_path
    end
  end
end
