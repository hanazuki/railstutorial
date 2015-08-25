require 'test_helper'

class Api::UserLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test 'should return 401 when given information is invalid' do
    post api_login_path, session: {email: '', password: ''}

    assert_equal 401, response.status
  end

  test 'should return auth_token when givin information is valid' do
    post api_login_path, session: {email: @user.email, password: 'password'}

    json = JSON.parse(response.body)

    assert_equal 201, response.status
    assert_not_empty json["auth_token"]
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
