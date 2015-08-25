require 'test_helper'

class Api::UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @headers = {"Authorization" => token_for(@user)}
  end

  test 'unsuccessful edit should return 422' do
    user_params = {
      user: {
        name:                  '',
        email:                 'foo@invalid.',
        password:              'foo',
        password_confirmation: 'bar'
      }
    }
    patch api_user_path(@user), user_params, @headers

    @user.reload

    assert_equal 422, response.status
    assert_not_equal 'foo@invalid', @user.email
  end

  test 'successful edit should return 202' do
    name  = 'Foo Bar'
    email = 'foo@bar.com'

    user_params = {
      user: {
        name:  name,
        email: email,
        password: "",
        password_confirmation: ""
      }
    }
    patch api_user_path(@user), user_params, @headers

    assert_equal 202, response.status

    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
