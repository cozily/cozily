ActionController::Routing::Routes.draw do |map|
  Clearance::Routes.draw(map)

  map.resources :addresses,
                :collection => { :geocode => :get }
  map.resources :apartments,
                :member => { :transition => :put }
  map.resources :neighborhoods
  map.resource  :search
  map.resources :users do |user|
    user.resources :apartments, :only => :index
    user.resources :favorites
    user.resources :flags
  end

  map.root :controller => "welcome"
end
