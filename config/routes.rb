Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  resources :mark_systems

  resources :toasts do
    member do
      post '/share_to_group', to: 'toasts#share_to_group'
      get '/deny_to_group', to: 'toasts#deny_to_group'
      post '/add_child', to: 'toasts#add_child'
      get '/remove_child', to: 'toasts#remove_child'
    end

    collection do
      get '/search', to: 'toasts#index'
    end
  end

  resources :subjects do
    member do
      post '/share_to_teacher', to: 'subjects#share_to_teacher'
      get '/deny_to_teacher', to: 'subjects#deny_to_teacher'
    end

    collection do
      get '/search', to: 'subjects#index'
    end
  end

  resources :questions

  resources :groups do
    member do
      get  '/leave', to: 'groups#leave_group'
      post '/join', to: 'groups#join_group'
    end

    collection do
      get '/search', to: 'groups#index'
    end
  end

  devise_for :users, controllers: {registrations: 'devise_override/registrations'}

  resources :users do
    member do
      get  '/results', to: 'users#results'
    end

    collection do
      get  '/', to: 'users#index'
      get '/search', to: 'users#index'
      get  '/invite_code', to: 'users#generate_invite_code'
      get  '/change_locale', to: 'users#change_locale'
    end
  end

  post '/passing', to: 'toasts#show'

  resources :results do
    collection do
      get '/show', to: 'results#show', as: 'show'
      post '/export', to: 'results#export'
      get  '/', to: 'results#index'
    end
  end

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
