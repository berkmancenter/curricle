Rails.application.routes.draw do
  get 'path', to: 'path#index'

  get '/courses', to: 'courses#index'
  get '/courses/search', to: 'courses#index'
  post '/courses/search', to: 'courses#search'
  post '/courses/:id/add-to-tray', to: 'courses#add_to_tray'
  delete '/courses/:id/remove-from-tray', to: 'courses#remove_from_tray'

  root 'courses#index'
end
