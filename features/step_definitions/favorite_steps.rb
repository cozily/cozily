Then /^I can favorite the apartment$/ do
  apartment = Apartment.last
  visit apartment_path(apartment)

  page.should_not have_css("a:contains('remove from my favorites')")
  click_link "add to my favorites"

  click_link "remove from my favorites"
  page.should have_no_css("a:contains('remove from my favorites')")
  page.should have_css("a:contains('add to my favorites')")
end

Given /^I have favorites$/ do
  Factory(:favorite,
          :apartment => Factory(:apartment,
                                :state => "published"),
          :user => User.last)
end

Then /^I can view my favorites$/ do
  click_link "my favorites"
  current_path.should == user_favorites_path(the.user)

  the.user.favorites.each do |favorite|
    page.should have_css("a:contains('#{favorite.apartment.full_address}')")
  end
end

Then /^I cannot view another user's favorites$/ do
  visit user_favorites_path(Factory(:user))
  current_path.should == "/"
end
