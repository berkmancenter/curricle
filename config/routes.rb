Rails.application.routes.draw do
  get 'path', to: 'path#index'
  get 'search', to: 'search#index'
  root 'search#index'
end
