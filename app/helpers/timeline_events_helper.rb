module TimelineEventsHelper
  def event_text(event)
    case event.event_type
      when "state_changed_to_listed"
        apartment = event.subject
        actor = current_user && current_user == apartment.user ? "You" : apartment.user.first_name
        verb = "listed"
        subject = "a #{link_to "#{apartment.bedrooms.prettify} bedroom apartment", apartment} in #{apartment.neighborhoods.map(&:name).join(", ")}"
      else
        raise "no event text defined for #{event.event_type}"
    end
    [actor, verb, subject].join(" ")
  end
end