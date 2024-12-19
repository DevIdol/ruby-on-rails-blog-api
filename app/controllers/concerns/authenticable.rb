module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request
  end

  private

  def authenticate_request
    token = request_token
    decoded_token = JwtService.decode(token)

    if decoded_token && !BlacklistToken.exists?(token: token)
      @current_user = User.find_by(id: decoded_token["user_id"])
    else
      render_unauthorized
    end
  end

  def request_token
    request.headers["Authorization"]&.split(" ")&.last
  end

  # Authorize a user for a specific resource
  def authorize_user_for_resource(resource_user_id)
    return if @current_user&.id == resource_user_id

    render_unauthorized
  end

  # Authorize user by params[:id]
  def authorize_user_by_params_id
    return if @current_user&.id == params[:id].to_i

    render_unauthorized
  end

  def render_unauthorized
    render json: { message: "Unauthorized" }, status: :unauthorized
  end
end
