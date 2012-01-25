require File.dirname(__FILE__) + '/acceptance_helper'

feature "authentication" do
  scenario "some paths requires authentication" do
    @apartment = Factory(:apartment)
    @neighborhood = Neighborhood.first
    @user = Factory(:user)

    [dashboard_path,
     dashboard_listings_path,
     dashboard_matches_path,
     dashboard_favorites_path,
     dashboard_messages_path,
     new_apartment_path,
     edit_apartment_path(@apartment),
     edit_user_registration_path,
     edit_profile_path,
     destroy_user_session_path].each do |path|
      visit path

      current_path.should == new_user_session_path
      page.should have_content("Sign in")
    end
  end
end
