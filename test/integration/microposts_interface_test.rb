require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test 'micropost interface' do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'

    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: { content: '' }
    end
    assert_select 'div#error_explanation'

    # Valid submission
    content = 'This micropost really ties the room together'
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content, picture: picture }
    end
    assert assigns(:micropost).picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

    # Delete a post.
    assert_select 'a', text: t('microposts.micropost.delete')
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # Visit a different user.
    get user_path(users(:archer))
    assert_select 'a', text: t('microposts.micropost.delete'), count: 0
  end

  test 'micropost sidebar count' do
    log_in_as(@user)
    get root_path, locale: :en
    assert_match "#{@user.microposts.count} microposts", response.body

    @user = users(:mallory)  # mallory has no microposts
    log_in_as(@user)
    get root_path
    assert_match '0 microposts', response.body
    @user.microposts.create!(content: 'Hello')
    get root_path
    assert_match /1 micropost\b/, response.body
  end
end
