class Api::ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include SessionsHelper

  # Confirms a logged-in user
  def logged_in_user
    unless logged_in?
      @messages = ["Unauthorized"]
      render "api/shared/error_messages.json", status: :unauthorized
    end
  end
end
