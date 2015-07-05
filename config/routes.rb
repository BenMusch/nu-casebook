Rails.application.routes.draw do
  root                'application#index'
  get     'signup' => 'users#new'
  get     'login'  => 'sessions#new'
  post    'login'  => 'sessions#create'
  delete  'logout' => 'sessions#destroy'
  resources :users,               only: [:create, :new]
  resources :sessions,            only: [:create, :new, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :rounds,              only: [:new, :create, :edit, :update, :destroy]
  resources :cases
end
