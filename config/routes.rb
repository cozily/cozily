ActionController::Routing::Routes.draw do |map|
  Clearance::Routes.draw(map)

  map.resources :addresses,
                :collection => { :geocode => :get }
  map.resources :apartments,
                :member => { :transition => :put } do |apartment|
    apartment.resources :images
  end
  map.resources :neighborhoods,
                :collection => { :search => :get }
  map.resource  :search
  map.resources :users do |user|
    user.resources :apartments, :only => :index
    user.resources :favorites
    user.resources :flags
  end

  map.root :controller => "welcome"
end
