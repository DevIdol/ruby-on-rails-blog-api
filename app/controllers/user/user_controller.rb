class User::UserController < ApplicationController
  before_action :authenticate_request
  before_action :set_user, only: [ :show, :destroy, :update ]

  # GET /users/:id
  def show
    if @current_user && @current_user.id == params[:id].to_i
      render json: @current_user, status: :ok
    else
      render json: { message: "Unauthorized" }, status: :unauthorized
    end
  end

  # DELETE /users/:id
  def destroy
    if @current_user && @current_user.id == params[:id].to_i
      @current_user.destroy
      render json: { message: "Account deleted successfully" }, status: :ok
    else
      render json: { message: "Unauthorized" }, status: :unauthorized
    end
  end

  # PATCH/PUT /users/:id
  def update
    if @current_user && @current_user.id == params[:id].to_i
      # Check if the username and/or password is being updated
      if update_username? && update_password?
        if @current_user.valid_password?(params[:old_password])
          @current_user.update(user_params)
          render json: { message: "Account updated successfully" }, status: :ok
        else
          render json: { message: "Old password is incorrect" }, status: :unprocessable_entity
        end
      elsif update_username?
        @current_user.update(username: params[:username])
        render json: { message: "Username updated successfully" }, status: :ok
      elsif update_password?
        if @current_user.valid_password?(params[:old_password])
          @current_user.update(password: params[:password], password_confirmation: params[:password_confirmation])
          render json: { message: "Password updated successfully" }, status: :ok
        else
          render json: { message: "Old password is incorrect" }, status: :unprocessable_entity
        end
      else
        render json: { message: "No valid fields to update" }, status: :unprocessable_entity
      end
    else
      render json: { message: "Unauthorized" }, status: :unauthorized
    end
  end

  private

  # Set the user based on the provided ID (params[:id])
  def set_user
    @user = User.find_by(id: params[:id])
    render json: { message: "User not found" }, status: :not_found unless @user
  end

  # Strong parameters for user data, now including username
  def user_params
    params.permit(:email, :password, :password_confirmation, :username)
  end

  # Check if the username field is provided
  def update_username?
    params[:username].present?
  end

  # Check if the password field is provided
  def update_password?
    params[:password].present? && params[:old_password].present?
  end
end
