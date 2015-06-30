require 'test_helper'

class LocaleTest < ActionDispatch::IntegrationTest
  test 'default locale' do
    get root_path
    assert_equal I18n.default_locale, I18n.locale
  end

  test 'locale paramter' do
    get root_path, locale: 'ja'
    assert_equal :ja, I18n.locale
    assert_select 'html[lang=ja]'
    get about_path
    assert_equal :ja, I18n.locale
    assert_select 'html[lang=ja]'

    get root_path, locale: 'en'
    assert_equal :en, I18n.locale
    assert_select 'html[lang=en]'
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
