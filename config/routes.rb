# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        resources :users, only: %i[index]
        get 'current_user', to: 'users#current'
      end
      resources :tweets, only: %i[index show create destroy] do
        member do
          get :comments
          post :retweets
        end
      end
    resources :comments, only: %i[create]
    resources :images, only: %i[update]
      mount_devise_token_auth_for 'User', at: 'users', controllers: {
        registrations: 'api/v1/users/registrations'
      }
      resources :users, param: :name, only: %i[show update]
    end
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
end