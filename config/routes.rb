Rails.application.routes.draw do
  root to: "closets#index"

  devise_scope :user do
    post "/confirm_email", to: "oauth_callbacks#confirm_email"
    get "/verify_email", to: "oauth_callbacks#verify_email"
    get '/users/:id/profile', to: "profile#show", as: 'profile'
  end

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  resources :closets
end
