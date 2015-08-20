require 'test_helper'

class Api::UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test 'index should return 401 when not logged in' do
    get :index

    json = JSON.parse(response.body)

    assert_equal 401, response.status
    assert_match /unauthorized/i, json["errors"].first
  end

  test 'update should return 401 when not logged in' do
    patch :update, id: @user, user: {name: @user.name, email: @user.email}

    json = JSON.parse(response.body)

    assert_equal 401, response.status
    assert_match /unauthorized/i, json["errors"].first
  end

  test 'update should return 403 when logged in as wrong user' do
    log_in_as(@other_user)
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

  test 'destroy should return 403 when logged in as a non-admin' do
    log_in_as(@other_user)

    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end

    json = JSON.parse(response.body)

    assert_equal 403, response.status
    assert_match /don't have permission/i, json["errors"].first
  end

  test 'should not allow the admin attribute to be edited via the web' do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch :update, id: @other_user, user: {name: 'TESTNAME', admin: '1'}

    @other_user.reload
    json = JSON.parse(response.body)

    assert_equal 202, response.status
    assert_equal 'TESTNAME', @other_user.name
    assert_not @other_user.admin?
  end

  test 'following should return 401 when not logged in' do
    get :following, id: @user

    json = JSON.parse(response.body)

    assert_equal 401, response.status
    assert_match /unauthorized/i, json["errors"].first
  end

  test 'followers should returen 401 when not logged in' do
    get :followers, id: @user

    json = JSON.parse(response.body)

    assert_equal 401, response.status
    assert_match /unauthorized/i, json["errors"].first
  end
end
