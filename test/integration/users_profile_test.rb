require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test 'profile page of an inactive user should not visible' do
    inactive_user, login_user = User.first(2)
    log_in_as(login_user)

    get user_path(inactive_user)
    assert_response :success

    inactive_user.update(activated: false, activated_at: nil)

    get user_path(inactive_user)
    assert_response :redirect
  end

  test 'profile display' do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
