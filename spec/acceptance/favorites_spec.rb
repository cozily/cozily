require File.dirname(__FILE__) + '/acceptance_helper'

feature "favorites" do
  scenario "user favorites an apartment", :js => true do
    login_as(Factory(:user))

    visit apartment_path(Factory(:published_apartment))

    page.should have_no_css("a:contains('remove from my favorites')")
    click_link "add to my favorites"

    click_link "remove from my favorites"
    page.should have_no_css("a:contains('remove from my favorites')")
    page.should have_css("a:contains('add to my favorites')")
  end

  scenario "user views their favorites" do
    user = Factory(:user)
    login_as(user)

    Factory(:favorite, :user => user)

    click_link "favorites"
    current_path.should == dashboard_favorites_path

    user.favorites.each do |favorite|
      page.should have_css("a:contains('#{favorite.apartment.full_address}')")
    end
  end
end