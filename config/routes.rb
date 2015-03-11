Rails.application.routes.draw do
  resources :mark_systems

  resources :toasts
  post '/toasts/:id/share_to_group', to: 'toasts#share_to_group', as: 'share_to_group'
  post '/toasts/:id/deny_group', to: 'toasts#deny_group'
  post '/passing', to: 'toasts#show'

  resources :subjects

  resources :questions

  resources :groups

  devise_for :users, controllers: { registrations: 'registrations' }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # user
  resources :users do
    get '/', to: 'users#index'
    get '/results', to: 'users#results'
  end

  post '/users/search', to: 'users#index', as: 'users_search'
  post '/toasts/search', to: 'toasts#index', as: 'toasts_search'
  post '/groups/search', to: 'groups#index', as: 'groups_search'
  post '/subjects/search', to: 'subjects#index', as: 'subjects_search'
  post '/results/search', to: 'results#show', as: 'results_show'

  get 'invite_code', to: 'users#generate_invite_code'
  post 'join_group', to: 'users#join_group'
  get 'leave_group/:id', to: 'users#leave_group', as: :leave_group

  # results
  get 'results', to: 'results#index'

  # You can have the root of your site routed with "root"
  root 'users#main'

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
