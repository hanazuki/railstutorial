require 'minitest/autorun'
require 'exercise4_1'

class TestExercise4_1 < Minitest::Test
  def test_empty_string
    assert_equal string_shuffle(''), ''
  end

  def test_shuffle_digits
    s = '0123456789'
    t = string_shuffle(s)
    assert_equal s.length, t.length
    s.each_char do |c|
      assert_includes t, c
    end
  end
end
