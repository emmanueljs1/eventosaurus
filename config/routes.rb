Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'
  resources :events
  resources :users
end
