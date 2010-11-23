module TimelineEventsHelper
  def event_text(event)
    case event.event_type
      when "state_changed_to_published"
        apartment = event.subject
        actor = current_user && current_user == apartment.user ? "You" : apartment.user.first_name
        verb = "published"
        subject = if apartment.bedrooms.present?
          "a #{link_to "#{apartment.bedrooms.prettify} bedroom apartment", apartment} in #{apartment.neighborhoods.map(&:name).join(", ")}"
        else
          "an #{link_to "apartment", apartment} in #{apartment.neighborhoods.map(&:name).join(", ")}"
        end
      when "state_changed_to_unpublished"
        apartment = event.subject
        actor = current_user && current_user == apartment.user ? "You" : apartment.user.first_name
        verb = "unpublished"
        subject = if apartment.bedrooms.present?
          "a #{link_to "#{apartment.bedrooms.prettify} bedroom apartment", apartment} in #{apartment.neighborhoods.map(&:name).join(", ")}"
        else
          "an #{link_to "apartment", apartment} in #{apartment.neighborhoods.map(&:name).join(", ")}"
        end
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
    [actor, verb, subject].join(" ").html_safe
  end
end