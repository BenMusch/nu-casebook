Rails.application.routes.draw do
  root             'application#index'
  get  'secret' => 'application#secret'
  get  'signup' => 'users#new'
  get  'login'  => 'sessions#new'
  post 'login'  => 'sessions#create'
  get  'logout' => 'sessions#destroy'
  resource :users
  resource :sessions
end
