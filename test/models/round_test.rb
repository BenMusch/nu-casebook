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
    @case = cases(:three)
    @win_tight_call = Round.new(case_id: 3, tight_call: true, win: true,
                                speaks: 50, rfd: "test rfd here")
    @win_no_tight_call = Round.new(case_id: 3, tight_call: false, win: true,
                                   speaks: 55, rfd: "test rfd here")

    @loss_tight_call = Round.new(case_id: 3, tight_call: true, win: false,
                                 speaks: 45, rfd: "test rfd here")
    @loss_no_tight_call = Round.new(case_id: 3, tight_call: false, win: false,
                                    speaks: 50, rfd: "test rfd here")
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

  test "callbacks properly update case stats" do
    rounds = [@win_tight_call,  @win_no_tight_call,
              @loss_tight_call, @loss_no_tight_call]
    win_percentages = [100, 100, 67, 50]
    tight_call_percentages = [100, 50, 67, 50]
    tight_call_win_percentages = [100, 100, 50, 50]
    speaks = [50, 52.5, 50, 50 ]
    rounds.each_with_index do |round, index|
      round.save
      @case.reload
      stats = @case.stats
      assert_in_delta stats[:win_percentage],
                      win_percentages[index], 1
      assert_in_delta stats[:tight_call_percentage],
                      tight_call_percentages[index], 1
      assert_in_delta stats[:tight_call_win_percentage],
                      tight_call_win_percentages[index], 1
      assert_in_delta stats[:average_speaks],
                      speaks[index], 0.001
    end
  end
end
