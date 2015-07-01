require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full title helper' do
    assert_equal t('layouts.base_title'), full_title
    assert_equal "Help | #{t('layouts.base_title')}", full_title('Help')
  end
end

