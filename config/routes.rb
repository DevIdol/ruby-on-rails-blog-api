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

  # Blog routes
  get "blogs/:id", to: "blog/blog#show", as: :show_blog
  get "blogs", to: "blog/blog#index", as: :blogs
  get "blogs/user/:user_id", to: "blog/blog#user_blogs", as: :user_blogs
  post "blogs", to: "blog/blog#create", as: :create_blog
  patch "blogs/:id", to: "blog/blog#update"
  put "blogs/:id", to: "blog/blog#update"
  delete "blogs/:id", to: "blog/blog#destroy", as: :destroy_blog
  # resources :blogs, only: [ :index, :show, :create, :update, :destroy ]
end
