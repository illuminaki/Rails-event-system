
require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  devise_for :users
  resources :events
  # Defines the root path route ("/")
  root "events#index"

  mount OasRails::Engine => '/docs'
  
  namespace :api do
    namespace :v1 do
      resources :events, only: [:show, :create]
    end
  end

  authenticate :user do  # Add authentication if needed
    mount Sidekiq::Web => '/sidekiq'
  end
  
end
