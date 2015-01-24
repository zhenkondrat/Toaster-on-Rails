Rails.application.routes.draw do
  resources :mark_systems

  resources :toasts

  resources :subjects

  resources :questions

  devise_for :users, controllers: { :registrations => 'registrations' }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # user
  post 'search_toast' => 'users#admin'
  get 'invite_code' => 'users#generate_invite_code'
  get 'admin' => 'users#admin'
  get 'student' => 'users#student'

  # journal
  post '/journal' => 'journal#index'
  post '/save_user_info' => 'journal#save_user_info'
  get '/journal' => 'journal#index'
  get '/user_info/:id' => 'journal#user_info', :as => 'user_info'
  get '/delete_users_group' => 'journal#delete_users_group'

  # toast
  post '/reg_group_toast' => 'toasts#reg_group'
  post '/toasts/:id' => 'toasts#show'
  get '/toasts/content/:id' => 'toasts#content'
  get '/del_group_toast' => 'toasts#del_group_from_list'
  get '/results' => 'toasts#results'

  # subject
  get '/subject/new' => 'subjects#new'
  post '/subjects' => 'subjects#create'
  get '/delete_subject' => 'subjects#delete'
  post '/mark_systems/:id' => 'mark_systems#update'

  # You can have the root of your site routed with "root"
  root 'users#index'

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
