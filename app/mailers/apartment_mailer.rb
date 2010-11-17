include UsersHelper

class ApartmentMailer < ActionMailer::Base
  def unpublished_stale_apartment_notification(apartment)
    from "cozily-noreply@cozi.ly"
    recipients apartment.user.email
    subject "One of your apartments has been unpublished on Cozily..."
    body :apartment => apartment, :user => apartment.user
  end
end