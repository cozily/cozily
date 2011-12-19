include ApartmentsHelper
include UsersHelper

class UserMailer < ActionMailer::Base
  include Resque::Mailer

  def first_apartment_notification(user_id)
    @user = User.find(user_id)

    from "support@cozi.ly"
    recipients @user.email
    subject "Thanks for creating a listing on Cozily"
  end

  def finder_summary(user_id)
    @user = User.find(user_id)

    @latest_matches = @user.matches.select { |a| a.published_at >= 1.week.ago } if @user.matches.present?
    mail(:from => "cozily-noreply@cozi.ly",
         :to => @user.email,
         :subject => "Your Weekly Match Summary from Cozily",
         :css => :email)
  end

  def lister_summary(user_id)
    @user = User.find(user_id)

    mail(:from => "cozily-noreply@cozi.ly",
         :to => @user.email,
         :subject => "Your Weekly Listing Summary from Cozily",
         :css => :email)
  end
end
