
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
  conversation = Factory(:conversation,
                         :sender => the.user,
                         :apartment => apartment)

  visit dashboard_messages_path
  current_path.should == dashboard_messages_path
  page.should have_content(conversation.body)
end

Then /^I can view replies to a message$/ do
  user = Factory(:user, :email_confirmed => true)
  apartment = Factory(:apartment, :user => user)
  conversation = Factory(:conversation,
                         :sender => the.user,
                         :apartment => apartment)
  message = Factory(:message,
                    :conversation => conversation,
                    :sender => apartment.user)

  visit dashboard_messages_path
  current_path.should == dashboard_messages_path

  page.should have_css("ul.tabs li a:contains('Inbox (1)')")
  find("div.conversations ul.conversation li.info").click
  page.should have_css("div.messages li:contains('#{conversation.body}')")
  page.should have_no_css("ul.tabs li a:contains('Inbox (1)')")
end

Then /^I can reply to a message$/ do
  apartment = Factory(:apartment)
  conversation = Factory(:conversation,
                         :sender => the.user,
                         :apartment => apartment)

  visit dashboard_messages_path
  current_path.should == dashboard_messages_path

  find("div.conversations ul.conversation li.info").click
  fill_in "message_body", :with => "Thanks for emailing me."
  click_button "Reply"
  page.should have_css("div.messages li:contains('Thanks for emailing me')")
end

Then /^I can message from the dashboard$/ do
  apartment = Factory(:apartment,
                      :state => "listed")

  Factory(:favorite,
          :apartment => apartment,
          :user => the.user)

  visit dashboard_favorites_path
  click_link "send message"

  page.should have_content("Message about #{apartment.street}")
  fill_in "message_body", :with => "I am the walrus."
  lambda {
    click_button "Send"
    page.should have_content("Message Sent")
  }.should change(Conversation, :count).by(1)
end