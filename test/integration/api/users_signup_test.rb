require 'test_helper'

class Api::UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'should return 422 when signup information is invalid' do
    assert_no_difference 'User.count' do
      post api_users_path, user: { name:  '', email: 'user@invalid.',
                               password: 'foo', password_confirmation: 'bar' }
    end
    assert_equal 422, response.status
  end

  test 'valid signup information with account activation' do
    assert_difference 'User.count', 1 do
      post api_users_path,
           user: { name:  'Example User', email: 'user@example.com',
                   password: 'password', password_confirmation: 'password' }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?

    # Try to get protected page before activation.
    get api_feed_path
    assert_equal 401, response.status

    # Try to activate with invalid token
    get edit_api_account_activation_path('invalid token')
    assert_equal 404, response.status

    # Try to activate with wrong email
    get edit_api_account_activation_path(user.activation_token, email: 'wrong')
    assert_equal 404, response.status

    # Activate with valid token and correct email
    get edit_api_account_activation_path(user.activation_token, email: user.email)
    assert_equal 200, response.status
    assert user.reload.activated?

    # ALready activated
    get edit_api_account_activation_path(user.activation_token, email: user.email)
    assert_equal 422, response.status
  end
end
