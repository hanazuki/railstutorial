require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)

    @delete_text = t('users.user.delete')
  end

  test 'index as admin including pagination and delete links' do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: @delete_text
      else
        assert_select 'a[href=?]', user_path(user), text: @delete_text, count: 0
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test 'index as non-admin' do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: @delete_text, count: 0
  end

  test 'index should not include inactive users' do
    inactive_user, login_user = User.first(2)
    log_in_as(login_user)

    get users_path
    assert_select 'a[href=?]', user_path(inactive_user), count: 1

    inactive_user.update(activated: false, activated_at: nil)

    get users_path
    assert_select 'a[href=?]', user_path(inactive_user), count: 0
  end
end
