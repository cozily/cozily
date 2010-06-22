ActionController::Routing::Routes.draw do |map|
  map.resources :addresses,
                :collection => { :geocode => :get }
  map.resources :apartments,
                :member => { :transition => :put } do |apartment|
    apartment.resources :images
  end
  map.resources :neighborhoods,
                :collection => { :search => :get }
  map.resource  :search
  map.resources :users, :controller => 'users', :only => [:edit, :update] do |user|
    user.resources :apartments, :only => :index
    user.resources :favorites
    user.resources :flags
  end

  map.business_search "yelp/business_search", :controller => "yelp", :action => "business_search"
  map.about "about", :controller => "pages", :action => "about"
  map.faq "faq", :controller => "pages", :action => "faq"

  Clearance::Routes.draw(map)

  map.root :controller => "welcome"
end
