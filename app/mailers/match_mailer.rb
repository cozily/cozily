include UsersHelper

class MatchMailer < ActionMailer::Base
  def new_match_notification(apartment, user)
    @apartment, @user = apartment, user
    from "cozily-noreply@cozi.ly"
    recipients user.email
    subject "A new apartment in #{apartment.neighborhoods.map(&:name).to_sentence} was published on Cozily..."
  end
end
