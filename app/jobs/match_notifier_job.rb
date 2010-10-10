class MatchNotifierJob
  attr_accessor :apartment_id

  def initialize(apartment)
    self.apartment_id = apartment.id
  end

  def perform
    apt = Apartment.find(apartment_id)

    User.finder.receive_match_notifications.each do |user|
      next if user == apt.user || user.has_received_match_notification_for?(apt)

      if apt.match_for?(user)
        MatchMailer.send_later(:deliver_new_match_notification, apt, user)
        MatchNotification.create(:user => user, :apartment => apt)
      end
    end
  end
end