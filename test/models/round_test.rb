require 'test_helper'

class RoundTest < ActiveSupport::TestCase
  def setup
    @round = Round.new(case_id: 1, rfd: "The case was not good",
                       win: false, speaks: 50)
    @joe = rounds(:joe)
    viewers(:joe).name = "Joe"
    @john = rounds(:john)
    viewers(:john).name = "John"
    @both = rounds(:both)
  end

  test "should reject invalid speaks" do
    @round.speaks = 43.75
    assert_not @round.valid?
    @round.speaks = 57
    assert_not @round.valid?
  end

  test "should reject blank RFDs" do
    @round.rfd = "      "
    assert_not @round.valid?
    @round.rfd = "too short"
    assert_not @round.valid?
  end

  test "should accept valid rounds" do
    assert @round.valid?
  end
end
