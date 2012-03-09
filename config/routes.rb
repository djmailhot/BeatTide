# Author:: Alex Miller, David Mailhot, Harnoor Singh, Tyler Rigsby,
#          Brett Webber, Melissa Winstanley
BeatTide::Application.routes.draw do
  get "users/search"
  post "users/find_user"

  get "faq", :controller => "pages"
  get "about", :controller => "pages"
  get "tutorial", :controller => "pages"

  get "/edit_profile" => "users#edit"
  put "/edit_profile" => "users#update"
  resources :users, :only => [:show, :index]

  get "feed", :controller => "pages"
  resources :subscriptions, :only => [:index, :create, :destroy]

  # Routes for creating and destroying a session (logging in or logging out)
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

  get "grooveshark/song_stream_info"
  get "grooveshark/search"
  get "grooveshark/songs_from_query"
  get "grooveshark/player"

  get "grooveshark/play_song"

  post "grooveshark/songs_from_query"

  # routes for posts
  post "/posts/like"
  get "/posts/show_raw"
  match "/posts", :to => "posts#create", :via => "post"
  match "/posts/:id" => "posts#show"

  match "/error", :to => "pages#error"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'pages#index'
  match "home" => 'pages#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
