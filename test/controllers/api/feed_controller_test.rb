require 'test_helper'

class Api::FeedControllerTest < ActionController::TestCase

  def setup
    @user = users(:michael)
    @request.headers["Authorization"] = token_for(@user)
  end

  test 'should return micropost feed as json' do
    get :index, format: :json

    json = JSON.parse(response.body)

    assert_equal 200, response.status
    assert json.is_a?(Array)

    expected_micropost_attrs = %w[id user content picture_url created_at].sort
    expected_user_attrs      = %w[id name avatar_url].sort
    json.each do |micropost|
      assert_equal expected_micropost_attrs, micropost.keys.sort
      assert_equal expected_user_attrs,      micropost["user"].keys.sort
    end
  end

  test 'should be able to paginate' do
    get :index, page: 1, format: :json
    feed_page_1 = JSON.parse(response.body)

    get :index, page: 2, format: :json
    feed_page_2 = JSON.parse(response.body)

    assert_not_equal feed_page_1, feed_page_2
  end

  test 'should return 402 if auth token is missing' do
    @request.headers["Authorization"] = ""
    get :index, format: :json

    assert 402, response.status
  end
end
