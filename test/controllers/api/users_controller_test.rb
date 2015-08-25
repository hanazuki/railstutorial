require 'test_helper'

class Api::UsersControllerTest < ActionController::TestCase
  def setup
    @user  = users(:michael)
    @other = users(:archer)
    @request.headers["Authorization"] = ""  # missing !!
  end

  test 'index should return 401 when auth_token is missing' do
    get :index

    json = JSON.parse(response.body)

    assert_equal 401, response.status
    assert_match /unauthorized/i, json["errors"].first
  end

  test 'update should return 401 when auth_token is missing' do
    patch :update, id: @user, user: {name: @user.name, email: @user.email}

    json = JSON.parse(response.body)

    assert_equal 401, response.status
    assert_match /unauthorized/i, json["errors"].first
  end

  test 'update should return 403 when logged in as wrong user' do
    @request.headers["Authorization"] = token_for(@other)

    patch :update, id: @user, user: {name: @user.name, email: @user.email}

    json = JSON.parse(response.body)

    assert_equal 403, response.status
    assert_match /don't have permission/i, json["errors"].first
  end

  test 'destroy should return 401 when not logged in' do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    json = JSON.parse(response.body)

    assert_equal 401, response.status
    assert_match /unauthorized/i, json["errors"].first
  end

  test "destroy should return 403 when the request has non-admin's token" do
    @request.headers["Authorization"] = token_for(@other)

    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end

    json = JSON.parse(response.body)

    assert_equal 403, response.status
    assert_match /don't have permission/i, json["errors"].first
  end

  test 'should not allow the admin attribute to be edited via the web' do
    @request.headers["Authorization"] = token_for(@other)

    assert_not @other.admin?
    patch :update, id: @other, user: {name: 'TESTNAME', admin: '1'}, format: 'json'

    @other.reload
    json = JSON.parse(response.body)

    assert_equal 202, response.status
    assert_equal 'TESTNAME', @other.name
    assert_not @other.admin?
  end

  test 'following should return 401 when auth_token is missing' do
    get :following, id: @user

    json = JSON.parse(response.body)

    assert_equal 401, response.status
    assert_match /unauthorized/i, json["errors"].first
  end

  test 'followers should returen 401 when auth_token is missing' do
    get :followers, id: @user

    json = JSON.parse(response.body)

    assert_equal 401, response.status
    assert_match /unauthorized/i, json["errors"].first
  end
end
