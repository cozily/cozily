ActionController::Routing::Routes.draw do |map|
  map.resources :addresses, :collection => {:geocode => :get}, :only => [:geocode]
  map.resources :apartments, :except => [:index], :member => {:order_images => :put, :transition => :put} do |apartment|
    apartment.resources :images, :only => [:create, :destroy]
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
  map.resources :users,
                :controller => 'users',
                :only => [:edit, :create, :update],
                :member => {:resend_confirmation => :post} do |user|
    user.resources :favorites, :only => [:create, :destroy]
    user.resources :flags, :only => [:create, :destroy]
    user.resource :profile, :only => [:edit], :controller => "users/profiles"
    user.resource :confirmation, :controller => 'confirmations', :only => [:new, :create]
  end

  map.resource :session, :controller => 'sessions', :only => [:create]

  map.business_search "yelp/business_search", :controller => "yelp", :action => "business_search"

  map.connect 'signup/:action', :controller => 'signup'

  map.with_options :controller => "dashboard" do |page|
    page.dashboard "dashboard", :action => "show"
    page.dashboard_listings "dashboard/listings", :action => "listings"
    page.dashboard_matches "dashboard/matches", :action => "matches"
    page.dashboard_favorites "dashboard/favorites", :action => "favorites"
    page.dashboard_messages "dashboard/messages", :action => "messages"
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

  map.namespace :admin do |admin|
    admin.home "", :controller => "base"
    admin.resources :apartments, :only => [:index]
    admin.resources :users, :only => [:index, :show, :activity], :collection => {:activity => :get}
  end

  map.resources :passwords,
                :controller => 'clearance/passwords',
                :only       => [:new, :create]

  map.resource :session,
               :controller => 'clearance/sessions',
               :only       => [:new, :create, :destroy]

  map.resources :users, :controller => 'clearance/users' do |users|
    users.resource :password,
                   :controller => 'clearance/passwords',
                   :only       => [:create, :edit, :update]

    users.resource :confirmation,
                   :controller => 'clearance/confirmations',
                   :only       => [:new, :create]
  end

  map.sign_up 'sign_up',
              :controller => 'clearance/users',
              :action     => 'new'
  map.sign_in 'sign_in',
              :controller => 'clearance/sessions',
              :action     => 'new'
  map.sign_out 'sign_out',
               :controller => 'clearance/sessions',
               :action     => 'destroy',
               :method     => :delete

  map.sitemap 'sitemap.xml', :controller => 'sitemap', :action => 'index'
  map.root :controller => "welcome"
end
