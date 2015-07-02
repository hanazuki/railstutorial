require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token

    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        mail = UserMailer.account_activation(user)
        assert_equal I18n.t('user_mailer.account_activation.subject', locale: locale), mail.subject
        assert_equal [user.email], mail.to
        assert_equal ["noreply@example.com"], mail.from
        assert_match user.name, mail.text_part.body.to_s
        assert_match user.activation_token, mail.text_part.body.to_s
        assert_match CGI::escape(user.email), mail.text_part.body.to_s
        assert_match user.name, mail.html_part.body.to_s
        assert_match user.activation_token, mail.html_part.body.to_s
        assert_match CGI::escape(user.email), mail.html_part.body.to_s
      end
    end
  end

  test "password_reset" do
    user = users(:michael)
    user.reset_token = User.new_token

    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        mail = UserMailer.password_reset(user)
        assert_equal I18n.t('user_mailer.password_reset.subject', locale: locale), mail.subject
        assert_equal [user.email], mail.to
        assert_equal ["noreply@example.com"], mail.from
        assert_match user.reset_token, mail.text_part.body.to_s
        assert_match CGI::escape(user.email), mail.text_part.body.to_s
        assert_match user.reset_token, mail.html_part.body.to_s
        assert_match CGI::escape(user.email), mail.html_part.body.to_s
      end
    end
  end

end
