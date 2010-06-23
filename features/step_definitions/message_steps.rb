Then /^I can message the owner$/ do
  visit apartment_path(Apartment.last)

  fill_in "message_body", :with => "I am the walrus."
  lambda {
    click_button "Send Message"
  }.should change(Message, :count).by(1)

  current_path.should == apartment_path(Apartment.last)
  page.should have_content("I am the walrus.")
end
