class ApplicationController < ActionController::API
  def authenticate_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header.present?

    decoded_token = JwtService.decode(token)

    if decoded_token
      @current_user = User.find_by(id: decoded_token["user_id"])
    else
      render json: { message: "Unauthorized" }, status: :unauthorized
    end
  end
end
