# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'landing#index'

  resources :courses do
    collection do
      get :categories
      get :fullsearch
      get :search
      get :courses_by_day
      post :add_to_tray
      delete :remove_from_tray
      post :add_to_schedule
      delete :remove_from_schedule
      get :user_courses
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
