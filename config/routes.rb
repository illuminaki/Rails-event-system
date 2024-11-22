Rails.application.routes.draw do
  devise_for :users
  resources :events
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "events#index"

  namespace :api do
    namespace :v1 do
      resources :tickets, only: [:create]
    end
  end
  
end
