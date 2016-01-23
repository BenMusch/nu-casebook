Rails.application.routes.draw do
  get 'bowlers'                  => 'bowlers#index'
  post 'bowlers/add_score'       => 'bowlers#post_score'
  post 'bowlers/create'          => 'bowlers#create'

  root                              'application#index'
  get     'signup'               => 'users#new'
  get     'login'                => 'sessions#new'
  post    'login'                => 'sessions#create'
  delete  'logout'               => 'sessions#destroy'
  get     'viewers'              => 'viewers#index'
  get     'topics'               => 'topics#index'
  get     'pick_case'            => 'rounds#pick_case'
  post    'get_case'             => 'rounds#get_case'

  resources :users,               only: [:create, :new]
  resources :sessions,            only: [:create, :new, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :searches,            only: [:create, :edit, :update, :show]
  resources :cases do
    resources :rounds,            except: [:show]
  end
end
