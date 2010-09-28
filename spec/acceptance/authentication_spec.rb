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
     apartment_path(@apartment),
     edit_apartment_path(@apartment),
     neighborhood_path(@neighborhood),
     edit_user_path(@user),
     edit_user_profile_path(@user),
     admin_users_path,
     sign_out_path,
     search_path].each do |path|
      visit path

      current_path.should == sign_in_path
      page.should have_content("Sign in")
    end
  end
end