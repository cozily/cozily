module FavoritesHelper
  def favorite_for_user_and_apartment(user, apartment)
    unless current_user.apartments.include?(apartment)
      link_to "favorite", favorites_path(:favorite => {:user_id => user.id, :apartment_id => apartment.id}), :'data-remote' => true
    else
      link_to "unfavorite", favorite_path(Favorite.find_by_user_id_and_apartment_id(user.id, apartment.id)), :'data-remote' => true, :'data-method' => 'delete'
    end
  end
end