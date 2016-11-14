Rails.application.routes.draw do

  devise_for :models
  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
#root 'welcome#index'
  
  root to: 'stories#index'
  
  resources :stories do 
    resources :comments
    resources :bookmarks
    resources :pictures, only: [:destroy, :new, :create]
  end
  
  namespace :admin do
    root to: 'stories#index'
    resources :stories
  end
  
  resources :dashboard, except: [:index] do
    member do
      get 'authored_stories'
      get 'bookmarked_stories'
      get 'commented_stories'
      get 'followers'
      get 'followings'
      get 'notifications'
    end
    devise_for :users, controllers: { registrations: 'registrations' }
  end
  
  resources :reactions, only: [:create, :destroy]
  
  resources :followings, only: [:show, :create, :destroy]
  
  resources :registration_steps, only: [:show, :update]
  
  get 'notifications/:id/mark_as_read' => 'notifications#mark_as_read', as: :mark_as_read
  
  get 'notifications/mark_all_as_read' => 'notifications#mark_all_as_read', as: :mark_all_as_read

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
