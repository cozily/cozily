module ApartmentsHelper
  def apartment_link(apartment)
    text = apartment.name.present? ? apartment.name : "Apartment ##{apartment.id}"
    path = apartment.listed? ? apartment_path(apartment) : edit_apartment_path(apartment)
    link_to text, path
  end

  def availability(apartment)
    if apartment.start_date.nil?
       "Availability unknown"
    elsif !apartment.sublet? || apartment.end_date.nil?
      "Available starting #{apartment.start_date.to_s(:app_short)}"
    else
      "Available #{apartment.start_date.to_s(:app_short)} through #{apartment.end_date.to_s(:app_short)}"
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
    apartment.listed? ? apartment_path(apartment) : edit_apartment_path(apartment)
  end

  def trains_for(station)
    return if station.trains.nil?
    "".tap do |trains|
      station.trains.split(//).each do |train|
        trains << image_tag("mta/#{train}.gif")
      end
    end
  end
end
