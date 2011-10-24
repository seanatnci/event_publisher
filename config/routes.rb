EventPublisher::Application.routes.draw do

  get "home/index"

  resources :users
  resources :sessions, :only => [:new, :create, :destroy]

  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/error', :to => 'home#error', :as => :error

  # match 'emails' => 'organizer/:id/emails#new'
  # match 'emails' => 'organizer/:id/emails#create',  :as => :emailcreate
  match 'organizer/:id/emails/csvup' => 'emails#csvup', :as => :csvup
  match 'organizer/:id/emails/emaillist' => 'emails#emaillist', :as => :emailupload, :via => :get
  match 'events/viewevents' => 'events#viewevents', :as => :view_events, :via => :post
  match 'events/selectevents' => 'events#selectevents', :as => :select_events, :via => :get
  match 'locations/findlocations' => 'locations#findlocations', :as => :find_locations, :via => :get

  #resources :emails
  #match 'organizers/:id/emails/:id' => 'emails#destroy', :as => :emaildelete, :via => :delete
  resources :overlays
  match 'overlays' => 'overlays#overlays'
  resources :organizers do
    resources :emails
  
  end
  match 'organizers/:id/emails/:id/destroy' => 'emails#destroy', :as => :emaildelete, :via => :delete
  resources :events
  resources :locations 
     
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
  root :to => "home#index"
  match "*", :to => "home#error"
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
