require 'test_helper'

class Api::UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test 'unsuccessful edit should return 422' do
    log_in_as(@user)
    patch api_user_path(@user),
          user: {name: '', email: 'foo@invalid.',
                 password: 'foo', password_confirmation: 'bar'}

    @user.reload

    assert_equal 422, response.status
    assert_not_equal 'foo@invalid', @user.email
  end

  test 'successful edit should return 202' do
    name  = 'Foo Bar'
    email = 'foo@bar.com'

    log_in_as(@user)
    patch api_user_path(@user),
          user: {name: name, email: email,
                 password: '', password_confirmation: ''}

    assert_equal 202, response.status

    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
