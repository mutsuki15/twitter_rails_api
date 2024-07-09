# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
    resources :tweets, only: %i[index show create]
    resources :images, only: %i[update]
      mount_devise_token_auth_for 'User', at: 'users', controllers: {
        registrations: 'api/v1/users/registrations'
      }
      resources :users, param: :name, only: %i[show update]
    end
  end
  resources :tasks
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
end