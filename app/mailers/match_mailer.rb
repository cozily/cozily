class MatchMailer < ActionMailer::Base
  def new_match_notification(apartment, user)
    from "support@cozi.ly"
    recipients user.email
    subject "A new apartment in #{apartment.neighborhoods.map(&:name).to_sentence} was listed on Cozily..."
    body :apartment => apartment
  end
end
