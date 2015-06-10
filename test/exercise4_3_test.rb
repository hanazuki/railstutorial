require 'minitest/autorun'
require 'exercise4_3'

class TestExercise4_3 < Minitest::Test
  def test_father_first
    assert_equal $params[:father][:first], 'Joel'
  end
end
