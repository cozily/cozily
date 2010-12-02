include NeighborhoodsHelper

module UsersHelper
  def profile_summary(profile)
    summary = ["matching"]

    summary << if profile.try(:sublets)
                 case profile.sublets
                   when Profile::SUBLETS["include them"]
                     "apartments"
                   when Profile::SUBLETS["exclude them"]
                     "non-sublets"
                   when Profile::SUBLETS["only show them"]
                     "sublets"
                 end
               else
                 "apartments"
               end

    summary << if profile.try(:bedrooms)
                 "with at least #{pluralize(profile.bedrooms, "bedroom")}"
               else
                 "with any number of bedrooms"
               end

    summary << if profile.try(:rent)
                 "under $#{number_with_delimiter(profile.rent)}"
               else
                 "regardless of rent"
               end

    summary << if profile.try(:neighborhoods).try(:present?)
                 count = profile.neighborhoods.size
                 if count == 1
                   "in #{neighborhood_links(profile.neighborhoods)}"
                 elsif count == 2
                   "in a couple #{link_to('neighborhoods', neighborhoods_path)}"
                 elsif count < 5
                   "in a few #{link_to('neighborhoods', neighborhoods_path)}"
                 else
                   "in several #{link_to('neighborhoods', neighborhoods_path)}"
                 end
               else
                 "in all neighborhoods"
               end

    summary.join(" ").html_safe
  end

  def profile_icon_for_user_and_neighborhood(user, neighborhood)
    return unless user.profile

    image, text = if user.profile.neighborhoods.include?(neighborhood)
                    ["remove_small.png", "stop matching apartments in #{neighborhood.name}"]
                  else
                    ["add_small.png", "match apartments in #{neighborhood.name}"]
                  end

    link_to(image_tag("icons/#{image}"), neighborhood_profiles_path(:neighborhood_id => neighborhood.id), :'data-remote' => true, :title => text)
  end

  def profile_link_for_user_and_neighborhood(user, neighborhood)
    return unless user.profile
    text = if user.profile.neighborhoods.include?(neighborhood)
             "remove this neighborhood from your profile"
           else
             "add this neighborhood to your profile"
           end

    link_to text, neighborhood_profiles_path(:neighborhood_id => neighborhood.id), :'data-remote' => true
  end

  def roles(user)
    user.roles.map(&:name).map(&:titleize).join(", ")
  end
end