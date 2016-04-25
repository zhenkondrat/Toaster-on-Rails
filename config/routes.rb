Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  concern :searchable do
    collection do
      get '/search', action: :index
    end
  end

  resources :mark_systems

  resources :toasts, concerns: :searchable do
    member do
      post :change_groups
    end
  end

  resources :subjects, concerns: :searchable do
    member do
      post :change_teachers
    end
  end

  resources :questions

  resources :groups, concerns: :searchable do
    member do
      post :change_members
    end
  end

  devise_for :users, controllers: { registrations: 'devise_override/registrations' }

  resources :users, concerns: :searchable do
    member do
      get :results
    end
  end

  resources :results do
    collection do
      post :export
    end
  end

  resource :profile, controller: :profile, except: :destroy do
    post 'change_language/:name', action: 'change_language', as: :change_language
  end

  root 'profile#index'
end
