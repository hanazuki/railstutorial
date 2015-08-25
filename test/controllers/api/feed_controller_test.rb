require 'test_helper'

class Api::FeedControllerTest < ActionController::TestCase

  def setup
    @user = users(:michael)
    @request.headers["Authorization"] = token_for(@user)
  end

  test 'should return micropost feed as json' do
    get :index, {}

    assert_equal 200, response.status
    assert_equal @user.feed.to_json, response.body
  end

  test 'should return 402 if auth token is missing' do
    @request.headers["Authorization"] = ""
    get :index

    assert 402, response.status
  end
end
