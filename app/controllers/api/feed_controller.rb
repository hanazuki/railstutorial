class Api::FeedController < Api::ApplicationController
  before_action :set_current_user, only: [:index]

  def index
    @microposts = current_user.feed
    render template: "api/microposts/index"
  end
end
