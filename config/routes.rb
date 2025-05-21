Rails.application.routes.draw do
  get "styles/index"
  get "styles/show"
  resources :memberships
  resources :beer_clubs
  resources :users do
    post 'toggle_frozen', on: :member
  end
  get 'beerlist', to: 'beers#list'
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :memberships, only: [:new, :create, :destroy]
  resources :styles
  delete 'memberships', to: 'memberships#destroy'
  resources :beer_clubs
  root "breweries#index"
  get 'brewerylist', to: 'breweries#list'
  get "all_beers", to: "beers#index"
  get "signup", to: "users#new", as: :signup
  get "signin", to: "sessions#new", as: "signin"
  delete "signout", to: "sessions#destroy", as: "signout"
  get 'signout', to: 'sessions#destroy'
  resource :session, only: [ :new, :create, :destroy ]
  resources :places, only: [:index, :show]
  post 'places', to: 'places#search'
  # get 'ratings', to: 'ratings#index'
  # get 'ratings/new', to:'ratings#new'

  # post 'ratings', to: 'ratings#create'

  resources :ratings, only: [ :index, :new, :create, :destroy ]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
