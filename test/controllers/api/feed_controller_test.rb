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

    expected_attrs = %w[id user content picture_url created_at].sort
    json.each do |micropost|
      assert_equal expected_attrs, micropost.keys.sort
    end
  end

  test 'should return 402 if auth token is missing' do
    @request.headers["Authorization"] = ""
    get :index, format: :json

    assert 402, response.status
  end
end
