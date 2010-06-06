ActionController::Routing::Routes.draw do |map|
  Clearance::Routes.draw(map)

  map.resources :apartments
  map.resources :neighborhoods
  map.resources :users do |user|
    user.resources :favorites
  end

  map.root :controller => "welcome"
end
