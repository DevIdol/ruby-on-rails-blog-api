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
      render json: { message: "Unauthorized" }, status: :unauthorized
    end
  end

  def request_token
    header = request.headers["Authorization"]
    header&.split(" ")&.last
  end

  def authorize_user
    if @current_user.nil? || @current_user.id != params[:id].to_i
      render json: { message: "Unauthorized" }, status: :unauthorized
    end
  end
end
