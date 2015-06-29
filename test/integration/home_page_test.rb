require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    log_in_as(@user)
  end

  test 'stats on Home page' do
    get root_path
    assert_select '#following', text: @user.following.count.to_s
    assert_select '#followers', text: @user.followers.count.to_s
  end
end
