class Api::SessionsController < Api::ApplicationController
  include Api::SessionsHelper

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        render json: {auth_token: token_for(@user)}, status: :created
      else
        message = "Account not activated. Check your email for the activation link."
        render_errors [message], status: :forbidden
      end
    else
      render_errors ["Invalid email or password"], status: :unauthorized
    end
  end
end
