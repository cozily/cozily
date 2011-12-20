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
      Neighborhood.find_all_by_id(eval(session[:neighborhood_ids])).map(&:name).join(", ")
    end
  end

  def lady_text
    text = if signed_out?
             "Thanks for checking out Cozily.  #{link_to("Sign up", sign_up_path)} if you like what you see!"
           elsif !current_user.email_confirmed?
             "Hey #{current_user.first_name}, remember to confirm your email address. #{link_to("Resend link", resend_confirmation_user_path(current_user), :'data-remote' => true)}."
           elsif action_name == "messages"
             "Wow #{current_user.first_name}, people really seem to love talking to you!"
           else
             lady_messages.first
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
        !(controller_name == "users" && action_name == "new")
  end

  def lady_messages
    messages = [
      "Home interprets heaven. Home is heaven for beginners.",
      "A house is not a home unless it contains food and fire for the mind as well as the body.",
      "Be grateful for the home you have, knowing that at this moment, all you have is all you need.",
      "Decorate your home. It gives the illusion that your life is more interesting than it really is.",
      "Home is the most popular, and will be the most enduring of all earthly establishments.",
      "Home is the place where, when you have to go there, they have to take you in.",
      "Home wasn't built in a day.",
      "Home, nowadays, is a place where part of the family waits till the rest of the family brings the car back.",
      "If I were asked to name the chief benefit of the house, I should say: the house shelters day-dreaming, the house protects the dreamer, the house allows one to dream in peace.",
      "Never make your home in a place. Make a home for yourself inside your own head. You'll find what you need to furnish it - memory, friends you can trust, love of learning, and other such things. That way it will go with you wherever you journey.",
      "The fellow that owns his own home is always just coming out of a hardware store.",
      "The home is the chief school of human virtues.",
      "The home to everyone is to him his castle and fortress, as well for his defense against injury and violence, as for his repose.",
      "There is nothing like staying at home for real comfort.",
      "There are only two things we should fight for. One is the defense of our homes and the other is the Bill of Rights.",
      "When I go home, its an easy way to be grounded. You learn to realize what truly matters.",
      "Where we love is home - home that our feet may leave, but not our hearts."
    ]

    messages << "Wow #{current_user.first_name}, that's a fabulous shirt you're wearing."

    Apartment.distinct_bedrooms.each do |bedrooms|
      apartments = Apartment.where(:bedrooms => bedrooms, :sublet => false, :state => "published").order("RANDOM()")
      next if apartments.empty?

      apartment    = apartments.first
      neighborhood = apartment.neighborhoods.first

      messages << "The median rent of #{number_with_precision(bedrooms, :precision => 0)} bedroom apartments on Cozily is $#{number_with_delimiter(number_with_precision(apartments.map(&:rent).median, :precision => 0))}."
      messages << "The median square footage of #{number_with_precision(bedrooms, :precision => 0)} bedroom apartments on Cozily is #{apartments.map(&:square_footage).median}."
      messages << "Maybe you'd like to check out some apartments in #{link_to(neighborhood.name, neighborhood)}?"
    end

    messages.shuffle
  end
end
