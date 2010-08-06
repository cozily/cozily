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

  map.connect 'signup/:action', :controller => 'signup'

  map.with_options :controller => "pages" do |page|
    page.about_page "/about", :action => "about"
    page.faq_page "/faq", :action => "faq"
    page.privacy_policy_page "/privacy_policy", :action => "privacy_policy"
    page.terms_of_service_page "/terms_of_service", :action => "terms_of_service"
  end

  Clearance::Routes.draw(map)

  map.root :controller => "welcome"
end
