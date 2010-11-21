# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def body_classes
    classes = []
    classes << "admin" if controller.controller_path =~ /admin/
    classes << controller.controller_name
    classes << controller.action_name
    classes.join(" ")
  end

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
    text = if signed_out?
      "Thanks for checking out Cozily.  #{link_to("Sign up", sign_up_path)} if you like what see!"
    elsif !current_user.email_confirmed?
      "Hey #{current_user.first_name}, remember to confirm your email address. #{link_to("Resend link", resend_confirmation_user_path(current_user), :'data-remote' => true)}."
    elsif action_name == "messages"
      "Wow #{current_user.first_name}, people really seem to love talking to you!"
    else
      "Wow #{current_user.first_name}, that's a fabulous shirt you're wearing."
    end

    text.html_safe
  end

  def show_search?
    controller_name, action_name = controller.controller_name, controller.action_name
    (["welcome",
      "pages",
      "sessions",
      "passwords",
      "signup"].all? { |name| controller_name != name }) &&
           ! (controller_name == "users" && action_name == "new")
  end
end
