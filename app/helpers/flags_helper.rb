module FlagsHelper
  def flag_for_user_and_apartment(user, apartment)
    unless user.flagged_apartments.include?(apartment)
      link_to "flag this", user_flags_path(user, :flag => {:apartment_id => apartment.id}), :'data-remote' => true, :'data-tip' => flag_tip
    else
      link_to "unflag this", user_flag_path(user, Flag.find_by_user_id_and_apartment_id(user.id, apartment.id)), :'data-remote' => true, :'data-method' => 'delete'
    end
  end

  def flag_tip
    "flag this apartment if it doesn't meet our standards.  like if the lister charges a fee " +
        "or it's a vacation rental or the apartment is otherwise bogus.  help us maintain the quality of our listings."
  end
end