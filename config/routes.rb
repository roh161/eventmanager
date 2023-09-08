Rails.application.routes.draw do
  root 'pages#home'
  # resources :events

  resources :events do
    collection do
      get :my_events
    end
  end
    
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
