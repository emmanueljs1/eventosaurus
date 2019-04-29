Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'
  resources :events do
    member do
      post '/invite', to: 'events#invite_user'
    end
  end
  resources :users do
    member do
      post '/accept_invite', to: 'users#accept_invite'
      post '/going', to: 'users#mark_going'
    end
  end
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
