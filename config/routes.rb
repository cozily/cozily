ActionController::Routing::Routes.draw do |map|
  map.resources :addresses,
                :collection => { :geocode => :get }
  map.resources :apartments,
                :member => { :order_images => :put,
                             :transition => :put } do |apartment|
    apartment.resources :images
    apartment.resources :messages
  end
  map.resources :feedback, :only => :create

  map.resources :neighborhoods,
                :collection => { :search => :get }

  map.resource  :search
  map.resources :users, :controller => 'users', :only => [:edit, :update] do |user|
    user.resources :apartments, :only => :index
    user.resources :favorites
    user.resources :flags
    user.resources :messages,
                   :controller => "users/messages"
    user.resource  :profile,
                   :controller => "users/profiles"
  end

  map.business_search "yelp/business_search", :controller => "yelp", :action => "business_search"
  map.dashboard "dashboard", :controller => "dashboard", :action => "show"

  map.with_options :controller => "pages" do |page|
    page.about "about", :action => "about"
    page.faq "faq", :action => "faq"
  end

  Clearance::Routes.draw(map)

  map.root :controller => "welcome"
end
