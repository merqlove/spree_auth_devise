Spree::Core::Engine.routes.draw do
  devise_for :spree_user,
             :class_name => 'Spree::User',
             :controllers => { :omniauth_callbacks: "spree/omniauth_callbacks",
                               :sessions => 'spree/user_sessions',
                               :registrations => 'spree/user_registrations',
                               :passwords => 'spree/user_passwords' },
             :skip => [:unlocks],
             :path_names => { :sign_out => 'logout' },
             :path => 'users'
end

Spree::Core::Engine.routes.prepend do
  resources :users, :only => [:edit, :update]

  devise_scope :spree_user do
    get '/login' => 'user_sessions#new', :as => :login
    post '/login' => 'user_sessions#create', :as => :create_new_session
    get '/logout' => 'user_sessions#destroy', :as => :logout
    # Necessary for #78
    get '/logout' => 'user_sessions#destroy', :as => :destroy_user_session
    get '/signup' => 'user_registrations#new', :as => :signup
    post '/signup' => 'user_registrations#create', :as => :registration
    get '/password/recover' => 'user_passwords#new', :as => :recover_password
    post '/password/recover' => 'user_passwords#create', :as => :reset_password
    get '/password/change' => 'user_passwords#edit', :as => :edit_password
    put '/password/change' => 'user_passwords#update', :as => :update_password
    
    post "spree_users/sign_up_social", to: "user_registrations#create_social", as: "social_user_registration"
  end

  match '/checkout/registration' => 'checkout#registration', :via => :get, :as => :checkout_registration
  match '/checkout/registration' => 'checkout#update_registration', :via => :put, :as => :update_checkout_registration

  match '/orders/:id/token/:token' => 'orders#show', :via => :get, :as => :token_order

  resource :session do
    member do
      get :nav_bar
    end
  end

  resource :account, :controller => 'users'

  namespace :admin do
    resources :users
  end
end
