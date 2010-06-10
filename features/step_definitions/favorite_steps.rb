Then /^I can favorite the apartment$/ do
  apartment = Apartment.last
  visit apartment_path(apartment)

  page.should_not have_css("a:contains('unfavorite')")
  lambda {
    click_link "favorite"
  }.should change(Favorite, :count).by(1)

  lambda {
    click_link "unfavorite"
  }.should change(Favorite, :count).by(-1)
end

Given /^I have favorites$/ do
  Factory(:favorite,
          :user => User.last)
end

Then /^I can view my favorites$/ do
  click_link "my favorites"
  current_path.should == user_favorites_path(User.last)

  User.last.favorites.each do |favorite|
    page.should have_css("a:contains('#{favorite.apartment.full_address}')")
  end
end

Then /^I cannot view another user's favorites$/ do
  visit user_favorites_path(Factory(:user))
  current_path.should == "/"
end
