require 'test_helper'

class Api::FetchingUsersTest < ActionDispatch::IntegrationTest
  def setup
    @user  = users(:michael)
  end

  test "index should return paginated all users" do
    log_in_as(@user)
    get api_users_path

    json = JSON.parse(response.body)

    assert json.is_a?(Array)
    assert json.all? {|user| (user.keys - %w[id name email]).empty? }
  end

  test "index should be paginated" do
    log_in_as(@user)

    get api_users_path, page: 1
    users_in_page_1 = JSON.parse(response.body)

    get api_users_path, page: 2
    users_in_page_2 = JSON.parse(response.body)

    assert_not_equal users_in_page_1, users_in_page_2

    assert_no_difference 'users_in_page_1.count' do
      users_in_page_1 = users_in_page_1 - users_in_page_2
    end
    assert_no_difference 'users_in_page_2.count' do
      users_in_page_2 = users_in_page_2 - users_in_page_1
    end
  end

  test "show should return an user including the microposts" do
    log_in_as(@user)
    get api_user_path(id: @user)

    json = JSON.parse(response.body)

    assert json.is_a?(Hash)
    assert_empty(json.keys - %w[id name email microposts following_count followers_count])

    assert_equal @user.following.count, json["following_count"]
    assert_equal @user.followers.count, json["followers_count"]

    attributes = ["id", "user_id", "content", "picture_url", "created_at"]
    assert json["microposts"].all? {|micropost|
      (attributes - micropost.keys).empty? && (micropost.keys - attributes).empty?
    }
  end

  test "each user's microposts should be paginated" do
    log_in_as(@user)

    get api_user_path(@user), page: 1
    microposts_in_page_1 = JSON.parse(response.body)["microposts"]

    get api_user_path(@user), page: 2
    microposts_in_page_2 = JSON.parse(response.body)["microposts"]

    assert_not_equal microposts_in_page_1, microposts_in_page_2

    assert_no_difference 'microposts_in_page_1.count' do
      microposts_in_page_1 = microposts_in_page_1 - microposts_in_page_2
    end
    assert_no_difference 'microposts_in_page_2.count' do
      microposts_in_page_2 = microposts_in_page_2 - microposts_in_page_1
    end
  end

  test "following should return following users" do
    log_in_as(@user)
    get following_api_user_path(@user)

    json = JSON.parse(response.body)

    assert json.is_a?(Array)
    assert User.where(id: json.map {|u| u["id"] }).all? {|user| @user.following? user }

    attributes = ["id", "name", "email"]
    assert json.all? {|user|
      (user.keys - attributes).empty? && (attributes - user.keys).empty?
    }
  end

  test "followers should return user's followers" do
    log_in_as(@user)
    get followers_api_user_path(@user)

    json = JSON.parse(response.body)

    assert json.is_a?(Array)
    assert User.where(id: json.map {|u| u["id"] }).all? {|user| @user.followed_by? user }

    attributes = ["id", "name", "email"]
    assert json.all? {|user|
      (user.keys - attributes).empty? && (attributes - user.keys).empty?
    }
  end
end
