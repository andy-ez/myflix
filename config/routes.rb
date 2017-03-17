Myflix::Application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  mount StripeEvent::Engine, at: '/stripe_events'

  get 'ui(/:action)', controller: 'ui'
  root to: 'pages#front'
  get '/register', to: 'users#new'
  get '/register/:token', to: 'users#new_with_invitation_token', as: "register_with_token"
  get '/login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/home', to: 'categories#index'
  get '/people', to: 'relationships#index'
  resources :users, except: [:new, :edit]
  get 'account', to: 'users#edit'
  get 'billing', to: 'users#plan_and_billing'
  post 'billing', to: 'users#plan_and_billing'
  resources :relationships, only: [:destroy, :create]
  resources :invitations, only: [:new, :create]
  get '/my_queue', to: 'queue_items#index'
  post '/update_queue', to: 'queue_items#update'
  get '/forgot_password', to: 'forgot_passwords#new'
  get '/confirm_password_reset', to: 'password_resets#confirm'
  get '/invalid_token', to: 'pages#invalid_token'
  resources :forgot_passwords, only: [:create]
  resources :password_resets, only: [:show, :create]
  resources :queue_items, only: [:create, :destroy]
  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end
  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
      get 'advanced_search', to: 'videos#advanced_search', as: 'advanced_search'
    end
    resources :reviews, only: [:create]
  end

  resources :categories, only: [:index, :show]
end
