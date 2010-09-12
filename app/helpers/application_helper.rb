# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def ip_lat
    session[:geo_location].try(:lat) || 40.7142691
  end

  def ip_lng
    session[:geo_location].try(:lat) || -74.0059729
  end

  def neighborhood_search_text
    if session[:neighborhood_ids].present?
      Neighborhood.find(session[:neighborhood_ids]).name
    else
      "All Neighborhoods"
    end
  end
end
