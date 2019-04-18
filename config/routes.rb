Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'
  resources :events
  resources :users
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
