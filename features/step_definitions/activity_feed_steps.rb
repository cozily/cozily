Then /^my activity feed should include apartments that were recently listed$/ do
  apartment = Factory(:apartment)
  apartment.list!

  visit "/"

  page.should have_content("#{apartment.user.first_name} listed a #{apartment.bedrooms.prettify} bedroom apartment in #{apartment.neighborhoods.map(&:name).join(", ")}")
end

Then /^my activity feed should include apartments that I (flagged|unflagged)$/ do |flagged_or_unflagged|
  apartment = Factory(:apartment)
  flag = Factory(:flag, :apartment => apartment, :user => the.user)
  flag.destroy if flagged_or_unflagged == "unflagged"

  visit "/"

  page.should have_content("You flagged #{apartment.name}")
  page.should have_content("You unflagged #{apartment.name}") if flagged_or_unflagged == "unflagged"
end

Then /^my activity feed should include apartments that I (favorited|unfavorited)$/ do |favorited_or_unfavorited|
  apartment = Factory(:apartment)
  favorite = Factory(:favorite, :apartment => apartment, :user => the.user)
  favorite.destroy if favorited_or_unfavorited == "unfavorited"

  visit "/"

  page.should have_content("You favorited #{apartment.name}")
  page.should have_content("You unfavorited #{apartment.name}") if favorited_or_unfavorited == "unfavorited"
end