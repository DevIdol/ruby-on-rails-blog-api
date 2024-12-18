class JwtService
  require "jwt"

  SECRET_KEY = Rails.application.credentials.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  def self.decode(token)
    decoded_token = JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")
    decoded_token.first
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end
end
