ActionController::Routing::Routes.draw do |map|
  map.resources :addresses, :collection => { :geocode => :get }, :only => [ :geocode ]
  map.resources :apartments, :except => [ :index ], :member => { :order_images => :put, :transition => :put } do |apartment|
    apartment.resources :images, :only => [ :create, :destroy ]
    apartment.resources :messages, :only => [ :create ]
    apartment.resources :conversations, :only => [ :create ]
  end
  map.resources :conversations, :only => [ :destroy ], :member => { :read => :put } do |conversation|
    conversation.resources :messages, :only => [ :create ]
  end

  map.resources :feedback, :only => [ :create ]
  map.resources :neighborhoods, :only => [ :show ], :collection => { :search => :get }

  map.resources :neighborhood_profiles, :only => [ :destroy ]

  map.resource  :search, :only => [ :show ]
  map.resources :users, :controller => 'users', :only => [ :edit, :create, :update ] do |user|
    user.resources :favorites, :only => [ :create, :destroy ]
    user.resources :flags, :only => [ :create, :destroy ]
    user.resource  :profile, :only => [ :edit ], :controller => "users/profiles"
  end

  map.resource :session, :controller => 'sessions', :only => [ :create ]

  map.business_search "yelp/business_search", :controller => "yelp", :action => "business_search"

  map.connect 'signup/:action', :controller => 'signup'

  map.with_options :controller => "dashboard" do |page|
    page.dashboard "dashboard", :action => "show"
    page.dashboard_listings "dashboard/listings", :action => "listings"
    page.dashboard_matches "dashboard/matches", :action => "matches"
    page.dashboard_favorites "dashboard/favorites", :action => "favorites"
    page.dashboard_messages "dashboard/messages", :action => "messages"
  end

  map.with_options :controller => "pages" do |page|
    page.about_page "/about", :action => "about"
    page.faq_page "/faq", :action => "faq"
    page.privacy_policy_page "/privacy_policy", :action => "privacy_policy"
    page.terms_of_service_page "/terms_of_service", :action => "terms_of_service"
  end

  map.namespace :admin do |admin|
    admin.resources :users, :only => [ :index ]
  end

  Clearance::Routes.draw(map)

  map.root :controller => "welcome"
end
