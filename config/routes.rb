# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'landing#index'

  devise_for :users

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end

  post '/graphql', to: 'graphql#execute'

  resources :tags do
    collection do
      get :search
      get :get_tags
      delete :remove
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
