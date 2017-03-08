Rails.application.routes.draw do

  get 'pages/terms'

  get 'pages/contacts'

  devise_for :models
  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'devise/user_sessions', passwords: 'devise/user_passwords', unlocks: 'devise/user_unlocks' }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
#root 'welcome#index'
  
  root to: 'stories#index'
  
  resources :stories do 
    resources :comments
    resources :bookmarks, only: [:create, :destroy]
    resources :pictures, only: [:destroy, :new, :create]
  end
  
  namespace :admin do
    root to: 'stories#index'
    get '/pattern' => 'stories#pattern'
    resources :stories do
      resources :classifications, only: [:destroy]
    end
  end
  
  resources :dashboard, except: [:index] do
    member do
      get 'authored_stories'
      get 'bookmarked_stories'
      get 'commented_stories'
      get 'reacted_stories'
      get 'followers'
      get 'followings'
      get 'notifications'
      get 'user_settings'
    end
    devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'devise/user_sessions' }
  end
  
  resources :reactions, only: [:create, :destroy]
  
  resources :followings, only: [:show, :create, :destroy]
  
  resources :registration_steps, only: [:show, :update]
  
  resources :notifications, only: [:destroy]
  get 'notifications/:id/mark_as_read' => 'notifications#mark_as_read', as: :mark_as_read
  
  get 'notifications/mark_all_as_read' => 'notifications#mark_all_as_read', as: :mark_all_as_read
  
  get 'notifications/destroy_all_read_notifications' => 'notifications#destroy_all_read_notifications', as: :destroy_all_read_notifications
  
  get 'notifications/mark_as_read_array' => 'notifications#mark_as_read_array', as: :mark_as_read_array

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
