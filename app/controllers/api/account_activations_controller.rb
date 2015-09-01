class Api::AccountActivationsController < Api::ApplicationController

  def edit
    @user = User.find_by(email: params[:email])
    if @user && !(activated = @user.activated?) &&
        (authenticated = @user.authenticated?(:activation, params[:id]))
      @user.activate
      render json: {auth_token: token_for(@user)}, status: :ok
    else
      if !@user
        render_errors ["User not found"], status: :not_found
      elsif activated
        render_errors ["User has already been activated"], status: :unprocessable_entity
      elsif !authenticated
        render_errors ["Invalid token"], status: :not_found
      end
    end
  end
end
