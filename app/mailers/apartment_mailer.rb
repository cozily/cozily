include UsersHelper

class ApartmentMailer < ActionMailer::Base
  def unpublished_stale_apartment_notification(apartment)
    @apartment, @user = apartment, apartment.user
    from "cozily-noreply@cozi.ly"
    recipients apartment.user.email
    subject "One of your apartments has been unpublished on Cozily..."
  end
end