Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: 'pages#front'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/home', to: 'categories#index'
  resources :users, except: [:new]
  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update'
  resources :queue_items, only: [:create, :destroy]
  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  resources :categories, only: [:index, :show]
end
