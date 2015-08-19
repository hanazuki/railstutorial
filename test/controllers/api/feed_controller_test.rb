require 'test_helper'

class Api::FeedControllerTest < ActionController::TestCase

  def setup
    @user = users(:michael)
  end

  test 'should return micropost feed as json' do
    log_in_as(@user)
    get :index

    assert_equal 200, response.status
    assert_equal @user.feed.to_json, response.body
  end

  test 'should return 402 if user is not logged in' do
    get :index

    assert 402, response.status
  end
end
