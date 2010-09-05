Given(/^there are searchable apartments$/) do
  Factory.create(:apartment, :bedrooms => 2, :bathrooms => 1, :rent => 2000, :state => 'unlisted')
  Factory.create(:apartment, :bedrooms => 2, :bathrooms => 0.5, :rent => 1700, :state => 'listed')
  Factory.create(:apartment, :bedrooms => 1, :bathrooms => 1, :rent => 1800, :state => 'unlisted')
  Factory.create(:apartment, :bedrooms => 2, :bathrooms => 1, :rent => 2300, :state => 'listed')

  visit search_path
end

Given(/^searching for apartments yields the correct results$/) do
  pending "advanced search"
  select "1", :from => "Min bedrooms"
  select "2", :from => "Max bedrooms"
  select "0.5", :from => "Min bathrooms"
  select "1.5", :from => "Max bathrooms"
  fill_in "Min rent", :with => "1500"
  fill_in "Max rent", :with => "2500"
  fill_in "Min square footage", :with => "100"
  fill_in "Max square footage", :with => "750"

  click_button 'search'
  page.should have_content("2 apartments found")
end
