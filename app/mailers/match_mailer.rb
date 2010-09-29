include UsersHelper

class MatchMailer < ActionMailer::Base
  def new_match_notification(apartment, user)
    from "cozily-noreply@cozi.ly"
    recipients user.email
    subject "A new apartment in #{apartment.neighborhoods.map(&:name).to_sentence} was listed on Cozily..."
    body :apartment => apartment, :user => user
  end
end
