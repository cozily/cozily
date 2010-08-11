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
  message = Factory(:message,
                    :apartment => apartment,
                    :sender => the.user)

  visit user_messages_path(the.user)
  current_path.should == user_messages_path(the.user)
  page.should have_content(message.body)
end
