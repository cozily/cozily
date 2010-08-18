module TimelineEventsHelper
  def event_text(event)
    case event.event_type
      when "state_changed_to_listed"
        apartment = event.subject
        actor = current_user && current_user == apartment.user ? "You" : apartment.user.first_name
        verb = "listed"
        subject = "a #{link_to "#{apartment.bedrooms.prettify} bedroom apartment", apartment} in #{apartment.neighborhoods.map(&:name).join(", ")}"
      when "state_changed_to_unlisted"
        apartment = event.subject
        actor = current_user && current_user == apartment.user ? "You" : apartment.user.first_name
        verb = "unlisted"
        subject = "a #{link_to "#{apartment.bedrooms.prettify} bedroom apartment", apartment} in #{apartment.neighborhoods.map(&:name).join(", ")}"
      when "state_changed_to_leased"
        apartment = event.subject
        actor = current_user && current_user == apartment.user ? "You" : apartment.user.first_name
        verb = "leased"
        subject = "a #{link_to "#{apartment.bedrooms.prettify} bedroom apartment", apartment} in #{apartment.neighborhoods.map(&:name).join(", ")}"
      when "created"
        actor = "You"
        verb = case event.subject_type
          when "Flag" then "flagged"
          when "Favorite" then "favorited"
        end
        subject = "#{link_to event.secondary_subject.name, event.secondary_subject}"
      when "destroyed"
        actor = "You"
        verb = case event.subject_type
          when "Flag" then "unflagged"
          when "Favorite" then "unfavorited"
        end
        subject = "#{link_to event.secondary_subject.name, event.secondary_subject}"
      else
        raise "no event text defined for #{event.event_type}"
    end
    [actor, verb, subject].join(" ")
  end
end