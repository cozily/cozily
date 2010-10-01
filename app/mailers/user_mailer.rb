class UserMailer < ActionMailer::Base
  def first_apartment_notification(user)
    from "support@cozi.ly"
    recipients user.email
    subject "Thanks for creating a listing on Cozily"
    body :user => user
  end
end
