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

  def lady_text
    if !current_user.email_confirmed?
      "Hey #{current_user.first_name}, remember to confirm your email address."
    elsif action_name == "messages"
      "Wow #{current_user.first_name}, people really seem to love talking to you!"
    else
      "Wow #{current_user.first_name}, that's a fabulous shirt you're wearing."
    end
  end
end
