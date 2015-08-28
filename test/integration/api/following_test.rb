require 'test_helper'

class Api::FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user  = users(:michael)
    @other = users(:archer)
    @headers = {"Authorization" => token_for(@user)}
  end

  test 'follow via api' do
    assert_not @user.following?(@other)

    post follow_api_user_path(@other), {}, @headers

    assert @user.following?(@other)
    assert_equal 201, response.status
  end

  test 'unfollow via api' do
    @user.follow @other

    assert @user.following?(@other)

    delete follow_api_user_path(@other), {}, @headers

    assert_not @user.following?(@other)
    assert_equal 202, response.status
  end

  test 'follow should return 401 if not logged in' do
    post follow_api_user_path(@other), {}, @headers

    assert 401, response.status
  end

  test 'unfollow should return 401 if not logged in' do
    delete follow_api_user_path(@other), {}, @headers

    assert 401, response.status
  end

  test "following information: michael follows archer" do
    @user.follow @other
    @other.unfollow @user
    get follow_api_user_path(@other), {}, @headers

    json = JSON.parse(response.body)

    assert     json["following"]
    assert_not json["followed"]
  end

  test "following information: archer follows michael" do
    get follow_api_user_path(@other), {}, @headers

    json = JSON.parse(response.body)

    assert_not json["following"]
    assert     json["followed"]
  end

  test "following information: following each other" do
    @user.follow @other
    get follow_api_user_path(@other), {}, @headers

    json = JSON.parse(response.body)

    assert json["following"]
    assert json["followed"]
  end

  test "following information: not following each other" do
    @other.unfollow @user
    get follow_api_user_path(@other), {}, @headers

    json = JSON.parse(response.body)

    assert_not json["following"]
    assert_not json["followed"]
  end
end
