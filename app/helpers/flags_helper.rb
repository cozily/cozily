module FlagsHelper
  def flag_for_user_and_apartment(user, apartment)
    unless user.flagged_apartments.include?(apartment)
      link_to "flag", user_flags_path(user, :flag => {:apartment_id => apartment.id}), :'data-remote' => true
    else
      link_to "unflag", user_flag_path(user, Flag.find_by_user_id_and_apartment_id(user.id, apartment.id)), :'data-remote' => true, :'data-method' => 'delete'
    end
  end
end