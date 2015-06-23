require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  test 'profile page of an inactive user should not visible' do
    inactive_user, login_user = User.first(2)
    log_in_as(login_user)

    get user_path(inactive_user)
    assert_response :success

    inactive_user.update(activated: false, activated_at: nil)

    get user_path(inactive_user)
    assert_response :redirect
  end
end
