Rails.application.routes.draw do
  devise_scope :user do
    post "/confirm_email", to: "oauth_callbacks#confirm_email"
    get "/verify_email", to: "oauth_callbacks#verify_email"
  end

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "closets#index"

  resources :closets
end
