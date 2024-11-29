require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
    # translation
  scope "(:locale)", locale: /en|es|ja/ do

    devise_for :users
    resources :events
    # Defines the root path route ("/")
    root "events#index"

    namespace :api do
      namespace :v1 do
        resources :events, only: [:show, :create]
      end
    end

  end
  post '/api/v1/tickets', to: 'tickets#create'

  # sidekiq
  authenticate :user do  # Add authentication if needed
    mount Sidekiq::Web => '/sidekiq'
  end
  # documentation for api
  mount OasRails::Engine => '/docs'

end
