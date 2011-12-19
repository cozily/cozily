class MatchNotifierJob
  @queue = :cozily_matcher

  def self.perform(apartment_id)
    apartment = Apartment.find(apartment_id)

    User.finder.receive_match_notifications.each do |user|
      next if user == apartment.user || user.has_received_match_notification_for?(apartment)

      if apartment.match_for?(user)
        MatchNotification.create(:user => user, :apartment => apartment)
        MatchMailer.new_match_notification(apartment.id, user.id).deliver
      end
    end
  end
end
