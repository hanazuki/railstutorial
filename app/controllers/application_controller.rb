class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  before_action :set_locale

  # Confirms a logged-in user
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t(:login_required, scope: 'application')
      redirect_to login_url
    end
  end

  private

  def set_locale
    locale = params[:locale] || session[:locale]
    locale = I18n.default_locale unless I18n.locale_available?(locale)
    I18n.locale = session[:locale] = locale
  end
end
