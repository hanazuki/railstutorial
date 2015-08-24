class Api::FeedController < Api::ApplicationController
  before_action :set_current_user, only: [:index]

  def index
    render json: current_user.feed
  end
end
