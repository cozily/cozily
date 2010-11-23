require File.dirname(__FILE__) + '/acceptance_helper'

feature "messages" do
  before do
    @user = Factory(:email_confirmed_user)
    login_as(@user)
  end

  scenario "non-owner messages an owner", :js => true do
    apartment = Factory(:published_apartment)
    visit apartment_path(apartment)

    fill_in "message_body", :with => "I am the walrus."
    click_button "Send Message"

    current_path.should == apartment_path(apartment)
    within("div.message") do
      page.should have_content("I am the walrus.")
    end
  end

  scenario "user views their inbox", :js => true do
    apartment = Factory(:apartment)
    conversation = Factory(:conversation,
                           :sender => @user,
                           :apartment => apartment)

    visit dashboard_messages_path
    current_path.should == dashboard_messages_path
    page.should have_content(conversation.body)
  end

  scenario "user views replies to a message", :js => true do
    user = Factory(:email_confirmed_user)
    apartment = Factory(:apartment, :user => user)
    conversation = Factory(:conversation,
                           :sender => @user,
                           :apartment => apartment)
    Factory(:message,
            :conversation => conversation,
            :sender => apartment.user)

    visit dashboard_messages_path
    current_path.should == dashboard_messages_path

    page.should have_css("ul.tabs li a:contains('Inbox (1)')")
    find("div.conversations ul.conversation li.info").click
    page.should have_css("div.messages li:contains('#{conversation.body}')")
    page.should have_no_css("ul.tabs li a:contains('Inbox (1)')")
  end

  scenario "user replies to a message", :js => true do
    apartment = Factory(:apartment)
    Factory(:conversation,
            :sender => @user,
            :apartment => apartment)

    visit dashboard_messages_path
    current_path.should == dashboard_messages_path

    find("div.conversations ul.conversation li.info").click
    fill_in "message_body", :with => "Thanks for emailing me."
    click_button "Reply"
    page.should have_css("div.messages li:contains('Thanks for emailing me')")
  end

  scenario "user can delete a conversation", :js => true do
    apartment = Factory(:apartment)
    conversation = Factory(:conversation,
                           :sender => @user,
                           :apartment => apartment)

    visit dashboard_messages_path
    current_path.should == dashboard_messages_path

    find("div.conversations ul.conversation li.delete").click
    click_button "Yes"
    page.should have_no_css("div.messages ul.conversation")
    conversation.reload.sender_deleted_at.should_not == nil
  end

  scenario "user replies to a deleted conversation", :js => true do
    apartment = Factory(:apartment)
    conversation = Factory(:conversation,
                           :sender => @user,
                           :apartment => apartment)
    conversation.update_attribute(:receiver_deleted_at, Time.now())

    visit dashboard_messages_path
    current_path.should == dashboard_messages_path

    find("div.conversations ul.conversation li.info").click
    fill_in "message_body", :with => "Thanks for emailing me."
    click_button "Reply"
    page.should have_content("Message Sent")
    conversation.reload.receiver_deleted_at.should == nil
  end

  scenario "user messages from the dashboard", :js => true do
    apartment = Factory(:published_apartment)

    Factory(:favorite,
            :apartment => apartment,
            :user => @user)

    visit dashboard_favorites_path
    click_link "send message"

    page.should have_content("Message about #{apartment.street}")
    fill_in "message_body", :with => "I am the walrus."
    lambda {
      click_button "Send"
      page.should have_content("Message Sent")
    }.should change(Conversation, :count).by(1)
  end
end