Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: 'pages#front'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/home', to: 'categories#index'
  get '/people', to: 'relationships#index'
  resources :users, except: [:new]
  resources :relationships, only: [:destroy, :create]
  get '/my_queue', to: 'queue_items#index'
  post '/update_queue', to: 'queue_items#update'
  get '/forgot_password', to: 'forgot_passwords#new'
  get '/confirm_password_reset', to: 'password_resets#confirm'
  get '/invalid_token', to: 'password_resets#invalid_token'
  resources :forgot_passwords, only: [:create]
  resources :password_resets, only: [:show, :create]
  resources :queue_items, only: [:create, :destroy]
  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  resources :categories, only: [:index, :show]
end
