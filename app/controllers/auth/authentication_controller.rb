class Auth::AuthenticationController < ApplicationController
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
      token = encode_token(user.id)
      render json: { token: token }, status: :ok
    else
      render json: { message: "Invalid credentials" }, status: :unauthorized
    end
  end

  private

  # request parameters
  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end

  # Helper method to encode JWT token
  def encode_token(user_id)
    payload = { user_id: user_id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end
end
