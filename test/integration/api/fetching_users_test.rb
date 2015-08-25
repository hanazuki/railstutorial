require 'test_helper'

class Api::FetchingUsersTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @headers = {"Authorization" => token_for(@user)}
  end

  test "index should return paginated all users" do
    get api_users_path, {}, @headers

    json = JSON.parse(response.body)

    assert json.is_a?(Array)

    expected_attrs = %w[id name avatar_url].sort
    json.each do |user|
      assert_equal expected_attrs, user.keys.sort
    end
  end

  test "index should be paginated" do
    get api_users_path, {page: 1}, @headers
    users_in_page_1 = JSON.parse(response.body)

    get api_users_path, {page: 2}, @headers
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
    get api_user_path(id: @user), {}, @headers

    json = JSON.parse(response.body)

    assert json.is_a?(Hash)

    expected_attrs = %w[id name avatar_url microposts following_count followers_count].sort
    assert_equal expected_attrs, json.keys.sort

    assert_equal @user.avatar_url,      json["avatar_url"]
    assert_equal @user.following.count, json["following_count"]
    assert_equal @user.followers.count, json["followers_count"]
  end

  test "each user's microposts should be paginated" do
    get api_user_path(@user), {page: 1}, @headers
    microposts_in_page_1 = JSON.parse(response.body)["microposts"]

    get api_user_path(@user), {page: 2}, @headers
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
    get following_api_user_path(@user), {}, @headers

    json = JSON.parse(response.body)

    assert json.is_a?(Array)
    assert User.where(id: json.map {|u| u["id"] }).all? {|user| @user.following? user }

    expected_attrs = %w[id name avatar_url].sort
    json.each do |user|
      assert_equal expected_attrs, user.keys.sort
    end
  end

  test "followers should return user's followers" do
    get followers_api_user_path(@user), {}, @headers

    json = JSON.parse(response.body)

    assert json.is_a?(Array)
    assert User.where(id: json.map {|u| u["id"] }).all? {|user| @user.followed_by? user }

    expected_attrs = %w[id name avatar_url].sort
    json.each do |user|
      assert_equal expected_attrs, user.keys.sort
    end
  end
end
