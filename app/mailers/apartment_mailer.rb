include UsersHelper

class ApartmentMailer < ActionMailer::Base
  include Resque::Mailer

  def unpublished_stale_apartment_notification(apartment_id)
    @apartment = Apartment.find(apartment_id)
    @user = @apartment.user

    from "cozily-noreply@cozi.ly"
    recipients @apartment.user.email
    subject "One of your apartments has been unpublished on Cozily..."
  end
end
