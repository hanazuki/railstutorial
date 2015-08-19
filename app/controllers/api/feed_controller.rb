class Api::FeedController < Api::ApplicationController
  before_action :logged_in_user, only: [:index]

  def index
    render json: current_user.feed
  end
end
