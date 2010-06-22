module ApartmentsHelper
  def apartment_link(apartment)
    text = apartment.name.present? ? apartment.name : "Apartment ##{apartment.id}"
    path = apartment.published? ? apartment_path(apartment) : edit_apartment_path(apartment)
    link_to text, path
  end
end