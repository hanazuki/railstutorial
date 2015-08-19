class Api::PasswordResetsController < Api::ApplicationController
  before_action :get_user,         only: [:update]
  before_action :valid_user,       only: [:update]
  before_action :check_expiration, only: [:update]

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      render json: "", status: :created
    else
      render_errors ["Email address not found"], status: :unprocessable_entity
    end
  end

  def update
    if params[:user][:password].blank?
      render_errors ["Password can't be blank"], status: :unprocessable_entity
    elsif @user.update(user_params)
      log_in @user
      render json: "", status: :accepted
    else
      render_errors @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless @user and @user.activated? and @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      render_errors ["Password reset has expired"], status: :bad_request
    end
  end
end
