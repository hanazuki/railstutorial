require 'minitest/autorun'
require 'exercise4_2'

class TestExercise4_2 < Minitest::Test
  def test_empty_string
    assert_equal ''.shuffle, ''
  end

  def test_shuffle_digits
    s = '0123456789'
    t = s.shuffle
    assert_equal s.length, t.length
    s.each_char do |c|
      assert_includes t, c
    end
  end
end
