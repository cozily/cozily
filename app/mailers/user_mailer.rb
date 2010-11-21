include UsersHelper

class UserMailer < ActionMailer::Base
  def first_apartment_notification(user)
    @user = user
    from "support@cozi.ly"
    recipients user.email
    subject "Thanks for creating a listing on Cozily"
  end

  def finder_summary(user)
    @user = user
    mail(:from => "cozily-noreply@cozi.ly",
         :to => user.email,
         :subject => "Your Weekly Match Summary from Cozily",
         :css => :email)
  end

  def lister_summary(user)
    @user = user
    mail(:from => "cozily-noreply@cozi.ly",
         :to => user.email,
         :subject => "Your Weekly Listing Summary from Cozily",
         :css => :email)
  end
end
