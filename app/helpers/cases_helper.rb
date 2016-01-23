module CasesHelper

  # Lists the stats
  def list_stats(a_case)
    tight_calls = a_case.tight_call_wins + a_case.tight_call_losses
    wins = a_case.wins
    losses = a_case.losses
    result = ""
    wins == 1 ? result += ("1 win | ") : result += ("#{wins} wins | ")
    losses == 1 ? result += ("1 loss | ") : result += ("#{losses} losses | ")
    tight_calls == 1 ? result += ("1 tight call") : result += ("#{tight_calls} tight calls")
    result += " | #{a_case.average_speaks} avg. speaks" if a_case.average_speaks > 0
    result
  end


  def average_speaks(a_case)
    a_case.average_speaks > 0 ? a_case.average_speaks.round(2) : "N/A"
  end
end
