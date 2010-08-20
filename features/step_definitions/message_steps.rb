
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

  visit dashboard_messages_path
  current_path.should == dashboard_messages_path
  page.should have_content(message.body)
end

Then /^I can view replies to a message$/ do
  apartment = Factory(:apartment)
  message = Factory(:message,
                    :apartment => apartment,
                    :sender => the.user)

  visit dashboard_messages_path
  current_path.should == dashboard_messages_path

  find("div.messages ul.root li.info").click
  page.should have_css("div.replies li:contains('#{message.body}')")
end

Then /^I can reply to a message$/ do
  apartment = Factory(:apartment)
  message = Factory(:message,
                    :apartment => apartment,
                    :sender => the.user)

  visit dashboard_messages_path
  current_path.should == dashboard_messages_path

  find("div.messages ul.root li.info").click
  fill_in "message_body", :with => "Thanks for emailing me."
  click_button "Reply"
  page.should have_css("div.replies li:contains('#{message.body}')")
end
