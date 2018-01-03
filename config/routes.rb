# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'landing#index'

  devise_for :users

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end

  post '/graphql', to: 'graphql#execute'

  resources :courses do
    collection do
      get :categories
      get :fullsearch
      get :search
      get :courses_by_day
      get :courses_by_year
      post :add_to_tray
      delete :remove_from_tray
      post :add_to_schedule
      delete :remove_from_schedule
      get :user_courses
    end
  end

  resources :tags do
    collection do
      get :search
      get :get_tags
      delete :remove
    end
  end

  resources :annotations do
    collection do
      get :get_annotations
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
