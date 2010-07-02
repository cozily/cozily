module ApartmentsHelper
  def apartment_link(apartment)
    text = apartment.name.present? ? apartment.name : "Apartment ##{apartment.id}"
    path = apartment.listed? ? apartment_path(apartment) : edit_apartment_path(apartment)
    link_to text, path
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
