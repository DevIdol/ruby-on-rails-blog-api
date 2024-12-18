Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_che

  # Auth routes
  post "register", to: "auth/authentication#register"
  post "login", to: "auth/authentication#login"
  post "logout", to: "auth/authentication#logout"

  # User routes
  get "users/:id", to: "user/user#show", as: :user_profile
  patch "users/:id", to: "user/user#update", as: :update_user
  delete "users/:id", to: "user/user#destroy", as: :delete_account
end
