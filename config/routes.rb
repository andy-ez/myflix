Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: 'categories#index'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  resources :users, except: [:new]
  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
  end
  resources :categories, only: [:index, :show]
end
