module FavoritesHelper
  def favorite_for_user_and_apartment(user, apartment)
    unless current_user.favorite_apartments.include?(apartment)
      link_to "favorite", user_favorites_path(user, :favorite => {:apartment_id => apartment.id}), :'data-remote' => true
    else
      link_to "unfavorite", user_favorite_path(user, Favorite.find_by_user_id_and_apartment_id(user.id, apartment.id)), :'data-remote' => true, :'data-method' => 'delete'
    end
  end
end