Rails.application.routes.draw do
  get 'path', to: 'path#index'
  get 'courses', to: 'courses#index'
  root 'courses#index'
end
