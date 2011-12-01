Ngg::Application.routes.draw do



  resources :comments

  resources :articles

  #match 'sa/:id' => 'sa#edit', :as => :sa
  resources :sa, :only => [:new, :create, :edit, :update, :show]



  match 'user/edit' => 'users#edit', :as => :edit_current_user

  match 'signup' => 'groups#new', :as => :signup
  match 'forgot' => 'sessions#forgot', :as => :forgot

  match 'logout' => 'sessions#destroy', :as => :logout
  
  match 'auth/:id' => 'sessions#auth', :as => :auth

  match 'login' => 'sessions#new', :as => :login
  match 'opps' => "home#opps", :as => :opps


  
  resources :home
  
  resources :images

  resources :members do
    resources :rounds, :only => [:index, :new]
    resources :images, :only => [:index, :new] 
    resources :quotas, :only => [:index, :new]
     
    member do
      get :invite
      get :teeopt
      put :invite
      get :init_rounds
    end
  end


  
  resources :groups do
    resources :images, :only => [:index, :new] 
    member do
      get :trim_rounds
    end
  end
  
  resources :rounds, :except => [:index, :new] 
  
  
  resources :courses do
    resources :tees, :only => [:index, :new]
    member do
      get :print
      
    end
  end
  resources :tees, :except => [:index, :new]
  
  resources :events do
    resources :rounds, :only => [:index, :new] 
    
    member do
      put :select
    end
  end
 
  resources :sessions

  resources :users do
    member do
      get :get
      put :set
    end
  end
  
  root :to => "home#index"

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
  #     user do
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
  # just reuser to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
