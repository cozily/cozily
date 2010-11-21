include NeighborhoodsHelper

module UsersHelper
  def profile_summary(profile)
    summary = ["matching"]
    summary << if profile.try(:bedrooms)
      "apartments with at least #{pluralize(profile.bedrooms.prettify, "bedroom")}"
    else
      "apartments with any number of bedrooms"
    end

    summary << if profile.try(:rent)
      "under $#{number_with_delimiter(profile.rent)}"
    else
      "regardless of rent"
    end

    summary << if profile.try(:neighborhoods).try(:present?)
      "in #{neighborhood_links(profile.neighborhoods)}"
    else
      "in all neighborhoods"
    end

    summary.join(" ").html_safe
  end

  def roles(user)
    user.roles.map(&:name).map(&:titleize).join(", ")
  end
end