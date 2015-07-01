require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test 'layout links' do
    get root_path
    assert_template 'static_pages/home'

    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path

    assert_select 'a[href=?]', login_path

    assert_select 'a[href=?]', users_path, count: 0
    assert_select 'a[href=?]', logout_path, count: 0

    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
  end

  test 'layout links for logged-in users' do
    user = users(:michael)
    log_in_as(user)

    get root_path
    assert_template 'static_pages/home'

    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path

    assert_select 'a[href=?]', login_path, count: 0

    assert_select 'a[href=?]', users_path
    assert_select 'a[href=?]', user_path(user)
    assert_select 'a[href=?]', edit_user_path(user)
    assert_select 'a[href=?]', logout_path

    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    get signup_path
    assert_select 'title', full_title(t('users.new.title'))
  end

  test 'sign-up page' do
    get signup_path
    assert_select 'title', full_title(t('users.new.title'))
  end
end
