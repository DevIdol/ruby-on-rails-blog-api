class Auth::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: [ :user_register, :register, :login ]

  def user_register
    render "auth/authentication/user_register"
  end

  # POST "/register"
  def register
    user = User.new(user_params)
    if user.save
      render json: { message: "User created successfully" }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST "/login"
  def login
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      token = JwtService.encode(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: { message: "Invalid credentials" }, status: :unauthorized
    end
  end

  # POST "/logout"
  def logout
    token = request_token

    if token
      BlacklistToken.create!(token: token)
      render json: { message: "Logged out successfully" }, status: :ok
    else
      render json: { message: "Token not provided" }, status: :bad_request
    end
  end

  private

  # Strong parameters
  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end
end
