Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_che

    # Register and Login routes
    post "register", to: "auth/authentication#register"
    post "login", to: "auth/authentication#login"
end
