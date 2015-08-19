require 'test_helper'

class Api::PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test 'should return 422 when email was invalid' do
    post api_password_resets_path, password_reset: {email: 'invaid'}
    assert_equal 422, response.status
  end

  test 'should return 201 when email was valid' do
    post api_password_resets_path, password_reset: {email: @user.email}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_equal 201, response.status
  end

  test 'should return 422 if user resets password with blank string' do
    post api_password_resets_path, password_reset: {email: @user.email}
    user = assigns(:user)

    patch api_password_reset_path(user.reset_token),
          email: user.email,
          user: {password: '', password_confirmation: ''}
    assert_equal 422, response.status
  end

  test "should return 422 if given password didn't pass the validations" do
    post api_password_resets_path, password_reset: {email: @user.email}
    user = assigns(:user)

    patch api_password_reset_path(user.reset_token),
          email: user.email,
          user: {password: 'abc', password_confirmation: 'abc'}

    json = JSON.parse(response.body)

    assert_equal 422, response.status
    assert json["errors"].any? {|msg| msg =~ /too short/i}
  end

  test 'should return 422 if confirmation did not match on reset' do
    post api_password_resets_path, password_reset: {email: @user.email}
    user = assigns(:user)

    patch api_password_reset_path(user.reset_token),
          email: user.email,
          user: {password: 'foobaz', password_confirmation: 'barquux'}
    assert_equal 422, response.status
  end

  test 'should make the user login if everything is ok' do
    post api_password_resets_path, password_reset: {email: @user.email}
    user = assigns(:user)

    patch api_password_reset_path(user.reset_token),
          email: user.email,
          user: {password: 'foobar', password_confirmation: 'foobar'}
    assert is_logged_in?, 'User should now be logged in'
    assert @user.reload.authenticate('foobar'), 'User should be able to login with the new password'
  end

  test 'expired token' do
    post api_password_resets_path, password_reset: { email: @user.email }

    @user = assigns(:user)
    @user.update(reset_sent_at: 3.hours.ago)

    patch api_password_reset_path(@user.reset_token),
          email: @user.email,
          user: { password: 'foobar', password_confirmation: 'foobar' }
    assert 201, response.status
  end
end
