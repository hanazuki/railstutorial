class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = I18n.t(:email_sent, scope: 'password_resets.create')
      redirect_to root_url
    else
      flash.now[:danger] = I18n.t(:email_not_found, scope: 'password_resets.create')
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].blank?
      flash.now[:danger] = I18n.t(:blank_password, scope: 'password_resets.update')
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = I18n.t(:password_reset, scope: 'password_resets.update')
      redirect_to @user
    else
      render 'edit'
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
      flash[:danger] = I18n.t(:expired_token, scope: 'password_resets')
      redirect_to new_password_reset_url
    end
  end
end
