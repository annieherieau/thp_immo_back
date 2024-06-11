# frozen_string_literal: true

Rails.application.routes.draw do
  resources :cities
  resources :listings
  get 'cities/:city_id/listings', to: 'listings#index_per_city'
  get 'users/:user_id/listings', to: 'listings#index_per_user'

  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations',
               passwords: 'users/passwords'
             },
             defaults: { format: :json }
  get '/myprofile', to: 'profiles#show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
