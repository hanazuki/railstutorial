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
    # Save locale in session when explicitly specified
    session[:locale] = params[:locale] if params[:locale] and I18n.locale_available?(params[:locale])

    # Locale defaults to HTTP_ACCEPT_LANGUAGE then the default locale
    locale = session[:locale] || http_accept_language.compatible_language_from(I18n.available_locales)
    I18n.locale = locale || I18n.default_locale
  end
end
