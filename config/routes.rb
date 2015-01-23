Rails.application.routes.draw do

  root 'tweets#index'
  get 'tweets', to: 'tweets#index'
  get 'tweets/index'
  get 'tweets/:id', to: 'tweets#show', as: 'tweet'
  post 'tweets', to: 'tweets#create'
  delete 'tweets/:id', to: 'tweets#destroy'
  get 'users/login'
  post 'users/login', to: 'users#attempt_login'
  post 'users/create'
  get 'users/edit', to: 'users#edit'
  post 'users/edit', to: 'users#update'
  get 'users/logout'
  get 'profile/:username', to: 'users#show', as: 'user'
  post 'follow/:username', to: 'users#follow'
  match 'search', to: 'users#search', via: [:get, :post]
  get 'profile/:username/follower', to: 'users#follower'
  get 'profile/:username/following', to: 'users#following'
  resources :users
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
