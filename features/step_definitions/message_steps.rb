Then /^I can message the owner$/ do
  visit apartment_path(Apartment.last)

  fill_in "message_body", :with => "I am the walrus."
  click_button "Send Message"

  current_path.should == apartment_path(Apartment.last)
  within("div.message") do
    page.should have_content("I am the walrus.")
  end
end

Then /^I can view my inbox$/ do
  apartment = Factory(:apartment)
  Factory(:message,
          :apartment => apartment,
          :sender => the.user)
  Factory(:message,
          :apartment => apartment,
          :receiver => the.user)

#  visit "/"
#  click_link "Inbox (1)"

  visit user_messages_path(the.user)
  current_path.should == user_messages_path(the.user)
end