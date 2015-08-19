class Api::SessionsController < Api::ApplicationController

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        remember @user

        render json: "", status: :created
      else
        message = "Account not activated. Check your email for the activation link."
        render_errors [message], status: :forbidden
      end
    else
      render_errors ["Invalid email or password"], status: :unauthorized
    end
  end

  def destroy
    log_out if logged_in?
    render json: "", status: :accepted
  end
end
