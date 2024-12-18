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
      token = JwtService.encode(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: { message: "Invalid credentials" }, status: :unauthorized
    end
  end

  private

  # Strong parameters
  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end
end
