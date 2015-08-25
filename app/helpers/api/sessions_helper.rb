module Api::SessionsHelper
  def set_current_user
    begin
      user_id = decode_token(request.headers["Authorization"])
      @current_user = User.find(user_id)
    rescue
      render json: {errors: ["Unauthorized"]}, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def current_user?(user)
    current_user == user
  end

  def token_for(user)
    "Bearer #{JWT.encode({user_id: user.id}, secret, 'HS256')}"
  end

  def decode_token(token)
    token.sub!(/^Bearer\s+/, "")
    JWT.decode(token, secret).first["user_id"]
  end

  private

  def secret
    Rails.application.secrets.secret_key_base
  end
end
