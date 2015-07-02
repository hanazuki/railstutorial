require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  def setup
    @base_title = t('layouts.base_title')
  end

  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", @base_title
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "#{t('static_pages.help.title')} | #{@base_title}"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "#{t('static_pages.about.title')} | #{@base_title}"
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "#{t('static_pages.contact.title')} | #{@base_title}"
  end
end
