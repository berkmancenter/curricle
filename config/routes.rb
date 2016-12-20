Rails.application.routes.draw do
  get 'path', to: 'path#index'

  get 'courses', to: 'courses#index'
  get 'courses/search', to: 'courses#index'
  post 'courses/search', to: 'courses#search'

  root 'courses#index'
end
