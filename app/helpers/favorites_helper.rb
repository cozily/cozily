module FavoritesHelper
  def favorite_for_user_and_apartment(user, apartment, count)
    unless user.favorite_apartments.include?(apartment)
      link_to "add to my favorites", user_favorites_path(user, :favorite => {:apartment_id => apartment.id}, :count => count), :'data-remote' => true, :class => 'add'
    else
      link_to "remove from my favorites", user_favorite_path(user, Favorite.find_by_user_id_and_apartment_id(user.id, apartment.id), :count => count), :'data-remote' => true, :'data-method' => 'delete', :class => 'remove'
    end
  end
end