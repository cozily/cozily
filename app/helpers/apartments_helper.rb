module ApartmentsHelper
  def apartment_link(apartment)
    text = apartment.name.present? ? apartment.name : "Apartment ##{apartment.id}"
    path = apartment.published? ? apartment_path(apartment) : edit_apartment_path(apartment)
    link_to text, path
  end

  def availability(apartment)
    if apartment.start_date.nil?
       "Availability Unknown"
    elsif !apartment.sublet? || apartment.end_date.nil?
      if apartment.start_date > Date.today
        "Available starting #{apartment.start_date.to_s(:quick)}"
      else
        "Available Immediately"
      end
    else
      "Available #{apartment.start_date.to_s(:quick)} through #{apartment.end_date.to_s(:quick)}"
    end
  end

  def last_state_change(apartment)
    text, date = if apartment.last_state_change.present?
      action = apartment.last_state_change.event_type.split("_")[3].titleize
      ["#{action} on", apartment.last_state_change.created_at]
    else
      ["Created on", apartment.created_at]
    end
    [text, date.to_date.to_s(:app_long)].join(" ")
  end

  def name_for_apartment(apartment)
    apartment.name.present? ? apartment.name : "Apartment ##{apartment.id}"
  end

  def path_for_apartment(apartment)
    apartment.published? ? apartment_path(apartment) : edit_apartment_path(apartment)
  end

  def trains_for(station)
    return if station.trains.nil?
    "".tap do |trains|
      station.trains.split(//).each do |train|
        trains << image_tag("mta/#{train}.gif")
      end
    end
  end

  def missing_associations(apartment)
    associations = apartment.missing_associations

    text = []
    text << link_to('provide your phone number', edit_profile_path) if associations.include?(:phone)

    output = if apartment.missing_fields.present?
      "Also, you need to " + text.to_sentence + "."
    else
      "You need to " + text.to_sentence + "."
    end

    output.html_safe
  end
end
