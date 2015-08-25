require 'test_helper'

class Api::UsersMeTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @headers = {"Authorization" => token_for(@user)}
  end

  test "request user should be assigned when get /api/users/me" do
    get api_user_path(id: "me"), {}, @headers

    assert_equal @user, assigns(:user)
  end

  test "request user should be assigned when put /api/users/me" do
    put api_user_path(id: "me"), {user: {name: "John Doe"}}, @headers

    assert_equal @user, assigns(:user)
  end

  test "request user should be assigned when delete /api/users/me" do
    delete api_user_path(id: "me"), {}, @headers

    assert_equal @user, assigns(:user)
  end

  test "request user should be assigned when get /api/users/me/following" do
    get following_api_user_path(id: "me"), {}, @headers

    assert_equal @user, assigns(:user)
  end

  test "request user should be assigned when get /api/users/me/followers" do
    get followers_api_user_path(id: "me"), {}, @headers

    assert_equal @user, assigns(:user)
  end
end
