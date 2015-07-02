Rails.application.routes.draw do
  root             'application#index'
  get  'secret' => 'application#secret'
  get  'signup' => 'users#new'
  get  'login'  => 'sessions#new'
  post 'login'  => 'sessions#create'
  get  'logout' => 'sessions#destroy'
  resources :users,    only: [:create, :new]
  resources :sessions, only: [:create, :new, :destroy]
  resources :account_activations, only: [:edit]
end
