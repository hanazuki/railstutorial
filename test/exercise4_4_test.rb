require 'minitest/autorun'
require 'exercise4_4'

class TestExercise4_4 < Minitest::Test
  def test_val
    assert_equal $val, { "a" => 100, "b" => 300 }
  end
end
