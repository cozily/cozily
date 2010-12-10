require File.dirname(__FILE__) + '/acceptance_helper'

feature "activity feed" do
  scenario "user views activity feed" do
    pending "activity feed feature"
    user = Factory(:email_confirmed_user, :phone => "800-555-1212")
    login_as(user)

    apartment = Factory(:apartment, :user => user)
    2.times { Factory(:image, :apartment => apartment) }
    apartment.publish!

    published_apartment = Factory(:published_apartment)
    flag = Factory(:flag, :apartment => published_apartment, :user => user)
    flag.destroy

    favorite = Factory(:favorite, :apartment => published_apartment, :user => user)
    favorite.destroy

    visit dashboard_path

    page.should have_content("You published a #{apartment.bedrooms.prettify} bedroom apartment in #{apartment.neighborhoods.map(& :name).join(", ")}")
    page.should have_content("You flagged #{published_apartment.name}")
    page.should have_content("You unflagged #{published_apartment.name}")
    page.should have_content("You favorited #{published_apartment.name}")
    page.should have_content("You unfavorited #{published_apartment.name}")
  end
end