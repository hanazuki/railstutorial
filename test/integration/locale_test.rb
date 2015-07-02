require 'test_helper'

class LocaleTest < ActionDispatch::IntegrationTest
  test 'default locale' do
    get root_path
    assert_equal I18n.default_locale, I18n.locale
  end

  test 'locale paramter' do
    # Default locale
    get root_path
    assert_select 'html[lang=?]', I18n.default_locale.to_s
    assert_nil session[:locale]

    # Respect browser setting
    get root_path, nil, {HTTP_ACCEPT_LANGUAGE: 'ja,en;q=0.5'}
    assert_select 'html[lang=ja]'
    assert_nil session[:locale]

    # Again respect browser setting
    get root_path, nil, {HTTP_ACCEPT_LANGUAGE: 'en,ja;q=0.5'}
    assert_select 'html[lang=en]'
    assert_nil session[:locale]

    # Respect user preference over browser settings
    get root_path, {locale: 'ja'}, {HTTP_ACCEPT_LANGUAGE: 'en,ja;q=0.5'}
    assert_select 'html[lang=ja]'
    assert_equal 'ja', session[:locale]

    # User preference should be saved across session
    get about_path, nil, {HTTP_ACCEPT_LANGUAGE: 'en,ja;q=0.5'}
    assert_select 'html[lang=ja]'

    # Override preference again
    get root_path, {locale: 'en'}, {HTTP_ACCEPT_LANGUAGE: 'en,ja;q=0.5'}
    assert_select 'html[lang=en]'
    assert_equal 'en', session[:locale]
  end

  test 'locale chooser' do
    get root_path
    assert_select '#locale-chooser'
    I18n.available_locales.each do |locale|
      assert_select '#locale-chooser a[href=?]', root_path(locale: locale)
    end

    get about_path
    assert_select '#locale-chooser'
    I18n.available_locales.each do |locale|
      assert_select '#locale-chooser a[href=?]', about_path(locale: locale)
    end
  end
end
