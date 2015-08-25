class Api::ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include Api::SessionsHelper

  def render_errors(error_messages, options)
    render options.merge(json: {"errors" => error_messages})
  end
end
