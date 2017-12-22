# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'landing#index'

  get '/courses/search', to: 'courses#search'
  resources :courses do
    collection do
      get :categories
    end
  end
  get '/courses/fullsearch', to: 'courses#fullsearch'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
