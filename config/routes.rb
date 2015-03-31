Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: 'registrations'}
  root  'static_pages#home'
  
  get   'help'    => 'static_pages#help'
  get   'about'   => 'static_pages#about'
  get   'contact' => 'static_pages#contact'

  resources :users do
    get 'history' => 'book_states#index'
    resources :requests
    resources :favorites
  end

  match '/users/:id/:type', to: 'users#show', via: :get
  resources :relationships, only: [:create, :destroy]

  resources :categories do
    resources :books
  end
  resources :books do
    resources :reviews
    resources :book_states
  end
  resources :reviews do
    resources :comments
  end
  resources :activities do
    resources :likes, only: [:create, :destroy]
  end

  namespace :admin do
    root 'static_pages#home'
    resources :users
    resources :categories
    resources :requests
    resources :books
  end

  resources :activities
end
