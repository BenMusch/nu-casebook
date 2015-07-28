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
    speaks = [50, 52.5, 50, 50]
    wins = [1, 2, 2, 2]
    losses = [0, 0, 1, 2]
    tight_call_wins = [1, 1, 1, 1]
    tight_call_losses = [0, 0, 1, 1]
    rounds.each_with_index do |round, index|
      round.save
      @case.reload
      #assert_in_delta @case.win_percentage,
      #                win_percentages[index], 1
      #assert_in_delta @case.tight_call_percentage,
      #                tight_call_percentages[index], 1
      #assert_in_delta @case.tight_call_win_percentage,
      #                tight_call_win_percentages[index], 1
      #assert_in_delta @case.average_speaks,
      #                speaks[index], 0.001
      assert_equal @case.wins, wins[index]
      assert_equal @case.losses, losses[index]
      assert_equal @case.tight_call_wins, tight_call_wins[index]
      assert_equal @case.tight_call_losses, tight_call_losses[index]
    end
    @loss_no_tight_call.win = true
    @loss_no_tight_call.tight_call = true
    @loss_no_tight_call.speaks = 55.0
    @loss_no_tight_call.save
    @case.reload
    assert_equal @case.wins, 3
    assert_equal @case.losses, 1
    assert_equal @case.tight_call_wins, 2
    assert_equal @case.tight_call_losses, 1
    assert_in_delta @case.win_percentage, 75.0, 1
    assert_in_delta @case.tight_call_percentage, 75.0, 1
    assert_in_delta @case. tight_call_win_percentage, 66.0, 1
    assert_in_delta @case.average_speaks, 51.25, 0.25
    rounds.reverse!
    win_percentages = [67, 100, 100, 0]
    tight_call_percentages = [66, 50, 100, 0]
    tight_call_win_percentages = [50, 100, 100, 0]
    speaks = [50, 52.5, 50, 0]
    wins = [2, 2, 1, 0]
    losses = [1, 0, 0, 0]
    tight_call_wins = [1, 1, 1, 0]
    tight_call_losses = [1, 0, 0, 0]
    rounds.each_with_index do |round, index|
      puts "iteration #{index}"
      round.destroy
      @case.reload
      assert_in_delta @case.win_percentage,
                      win_percentages[index], 1
      assert_in_delta @case.tight_call_percentage,
                      tight_call_percentages[index], 1
      assert_in_delta @case.tight_call_win_percentage,
                      tight_call_win_percentages[index], 1
      assert_in_delta @case.average_speaks,
                      speaks[index], 0.001
      assert_equal @case.wins, wins[index]
      assert_equal @case.losses, losses[index]
      assert_equal @case.tight_call_wins, tight_call_wins[index]
      assert_equal @case.tight_call_losses, tight_call_losses[index]
    end
  end
end
