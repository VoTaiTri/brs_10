Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: 'registrations'}
  root  'static_pages#home'
  
  get   'help'    => 'static_pages#help'
  get   'about'   => 'static_pages#about'
  get   'contact' => 'static_pages#contact'

  resources :users, only: [:index, :show, :edit] do
    get 'history' => 'book_states#index'
    resources :requests, only: [:index, :create, :destroy]
    resources :favorites, only: [:index, :create, :destroy]
  end

  match '/users/:id/:type', to: 'users#show', via: :get
  resources :relationships, only: [:create, :destroy]

  resources :categories, only: [:index] do
    resources :books
  end
  resources :books, only: [:index, :show] do
    resources :reviews, except: [:index, :new]
    resources :book_states, except: [:show, :destroy]
  end
  resources :reviews do
    resources :comments, only: [:create, :destroy]
  end
  resources :activities do
    resources :likes, only: [:create, :update, :destroy]
  end

  namespace :admin do
    root 'static_pages#home'
    resources :users, only: [:index, :show, :destroy]
    resources :categories, except: [:show]
    resources :requests, only: [:index, :update]
    resources :books, except: [:show]
  end

  get "rubyxl" => "export_rubyxl#index"
  get "export_file" => "export_rubyxl#new"
end