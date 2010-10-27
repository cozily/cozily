include UsersHelper

class UserMailer < ActionMailer::Base
  def first_apartment_notification(user)
    from "support@cozi.ly"
    recipients user.email
    subject "Thanks for creating a listing on Cozily"
    body :user => user
  end

  def finder_summary(user)
    css :email
    from "cozily-noreply@cozi.ly"
    recipients user.email
    subject "Your Weekly Match Summary from Cozily"
    body :user => user
  end

  def lister_summary(user)
    css :email
    from "cozily-noreply@cozi.ly"
    recipients user.email
    subject "Your Weekly Listing Summary from Cozily"
    body :user => user
  end
end
