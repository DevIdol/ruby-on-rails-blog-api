class User::UserController < ApplicationController
  before_action :authenticate_request
  before_action :set_user, only: [ :show, :destroy, :update ]
  before_action :authorize_user, only: [ :show, :destroy, :update ]

  # GET /users/:id
  def show
    render json: @current_user, status: :ok
  end

  # DELETE /users/:id
  def destroy
    @current_user.destroy
    render json: { message: "Account deleted successfully" }, status: :ok
  end

  # PATCH/PUT /users/:id
  def update
    result = UserService.new(@current_user, params).update_user
    render json: { message: result[:message] }, status: result[:status]
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render json: { message: "User not found" }, status: :not_found unless @user
  end

  def authorize_user
    if @current_user.id != params[:id].to_i
      render json: { message: "Unauthorized" }, status: :unauthorized
    end
  end
end
