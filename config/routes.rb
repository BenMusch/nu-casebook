Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'password_confirmation/new'

  get 'password_confirmation/edit'

  root             'application#index'
  get  'secret' => 'application#secret'
  get  'signup' => 'users#new'
  get  'login'  => 'sessions#new'
  post 'login'  => 'sessions#create'
  get  'logout' => 'sessions#destroy'
  resources :users,               only: [:create, :new]
  resources :sessions,            only: [:create, :new, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
