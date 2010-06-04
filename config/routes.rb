ActionController::Routing::Routes.draw do |map|
  Clearance::Routes.draw(map)

  map.resources :apartments
  map.resources :favorites

  map.root :controller => "welcome"
end
