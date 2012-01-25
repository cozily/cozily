Rails.application.routes.draw do |map|
  ActiveAdmin.routes(self)

  devise_for :users, :controllers => { :registrations => "registrations" }
  devise_for :admin_users, ActiveAdmin::Devise.config

  mount Resque::Server.new, :at => "/resque"

  map.resources :addresses, :collection => {:geocode => :get}, :only => [:geocode]
  map.resources :apartments, :except => [:index], :member => {:order_photos => :put, :transition => :put} do |apartment|
    apartment.resources :photos, :only => [:create, :destroy]
    apartment.resources :messages, :only => [:create]
    apartment.resources :conversations, :only => [:create]
  end
  map.resources :conversations, :only => [:destroy], :member => {:read => :put} do |conversation|
    conversation.resources :messages, :only => [:create]
  end

  map.resources :feedback, :only => [:create]
  map.resources :neighborhoods, :only => [:show, :index], :collection => {:search => :get}

  map.resources :neighborhood_profiles, :only => [:create, :destroy]

  map.resource :search, :only => [:show]
  map.resources :users do |user|
    user.resources :favorites, :only => [:create, :destroy]
    user.resources :flags, :only => [:create, :destroy]
    # user.resource :confirmation, :controller => 'confirmations', :only => [:new, :create]
  end
  resource :profile, :only => [:edit, :update], :controller => "users/profiles"

  map.business_search "yelp/business_search", :controller => "yelp", :action => "business_search"

  map.connect 'signup/:action', :controller => 'signup'

  map.with_options :controller => "dashboard" do |page|
    page.dashboard "dashboard", :action => "show"
    page.dashboard_listings "listings", :action => "listings"
    page.dashboard_matches "matches", :action => "matches"
    page.dashboard_map "map", :action => "map"
    page.dashboard_favorites "favorites", :action => "favorites"
    page.dashboard_messages "messages", :action => "messages"
    page.dashboard_fail "fail", :action => "fail"
  end

  map.with_options :controller => "browse" do |page|
    page.browse "browse", :action => "index"
  end

  map.with_options :controller => "pages" do |page|
    page.about_page "/about", :action => "about"
    page.faq_page "/faq", :action => "faq"
    page.privacy_policy_page "/privacy_policy", :action => "privacy_policy"
    page.terms_of_service_page "/terms_of_service", :action => "terms_of_service"
  end

  map.sitemap 'sitemap.xml', :controller => 'sitemap', :action => 'index'

  map.root :controller => "welcome"
  match '*route', :to => 'errors#routing'
end
