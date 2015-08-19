require 'test_helper'

class Api::UserLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test 'should return 401 when given information is invalid' do
    post api_login_path, session: {email: '', password: ''}

    assert_equal 401, response.status
  end

  test 'login with valid information followed by logout' do
    delete api_logout_path
    post api_login_path, session: {email: @user.email, password: 'password'}

    assert_equal 201, response.status
    assert_not_empty cookies["user_id"]
    assert_not_empty cookies["remember_token"]

    delete api_logout_path

    assert_equal 202, response.status

    assert_empty cookies["user_id"]
    assert_empty cookies["remember_token"]
  end

  test 'logout twice affects nothing' do
    delete api_logout_path

    assert_equal 202, response.status
    assert_not is_logged_in?

    delete api_logout_path

    assert_equal 202, response.status
    assert_not is_logged_in?
  end

  test "token should be remembered regardless of the remember_me parameter" do
    session_params = {email: @user.email, password: 'password'}

    post api_login_path, session: session_params.merge({remember_me: '1'})
    assert_equal cookies['remember_token'], assigns(:user).remember_token

    post api_login_path, session: session_params.merge({remember_me: '0'})
    assert_equal cookies['remember_token'], assigns(:user).remember_token

    post api_login_path, session: session_params.merge({remember_me: '0'})
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end
end
