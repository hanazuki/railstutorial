require 'test_helper'

class Api::FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other = users(:archer)
    log_in_as(@user)
  end

  test 'follow via api' do
    assert_not @user.following?(@other)

    post follow_api_user_path(@other)

    assert @user.following?(@other)
    assert_equal 201, response.status
  end

  test 'unfollow via api' do
    @user.follow @other

    assert @user.following?(@other)

    delete follow_api_user_path(@other)

    assert_not @user.following?(@other)
    assert_equal 202, response.status
  end
end
