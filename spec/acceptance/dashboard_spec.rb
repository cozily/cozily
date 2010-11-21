require File.dirname(__FILE__) + '/acceptance_helper'

feature "dashboard" do
  scenario "finder navigates their dashboard", :js => true do
    login_as(Factory(:lister, :role_ids => Role.all.map(&:id)))

    page.should have_css("ul.tabs li.active a:contains('My Listings')")

    ["Matches", "Favorites", "Inbox", "My Listings"].each do |link|
      within "ul.tabs" do
        click_link link
      end

      page.should have_css("ul.tabs li.active a:contains('#{link}')")
    end
  end
end