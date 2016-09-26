Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  get 'users/new'

  root 'static_pages#home'
  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  #json api
  namespace :api, {format: 'json'} do
    resources :users do
      get :microposts
      get :following, :followers
    end
    post 'auth' => 'sessions#create'
    resources :microposts, only: [:create, :destroy, :show]
    get 'feed' => 'users#feed'
    resources :relationships, only: [:create, :destroy]
    get 'lists' => 'users#lists'

    resources :lists, only: [:create, :destroy, :update, :show] do
      resources :members, only: [:create, :destroy, :index], module: :lists
      member do 
        get :feed
      end
    end
  end
end
