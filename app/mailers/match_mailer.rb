include UsersHelper

class MatchMailer < ActionMailer::Base
  include Resque::Mailer

  def new_match_notification(apartment_id, user_id)
    @apartment = Apartment.find(apartment_id)
    @user = User.find(user_id)

    from "cozily-noreply@cozi.ly"
    recipients @user.email
    subject "A new apartment in #{@apartment.neighborhoods.map(&:name).to_sentence} was published on Cozily..."
  end
end
