class BowlersController < ApplicationController
  include ApplicationHelper

  def index
    @bowlers = Bowler.all.order('avg_score desc')
  end

  def create
    if Bowler.create(name: params[:name], avg_score: 0, num_rounds: 0)
      redirect_to '/bowlers'
    else
      flash[:danger] = "oops there was an issue"
      redirect_to cases_path
    end
  end

  def post_score
    bowler = Bowler.find(params[:id])
    bowler.update_attribute(:num_rounds, bowler.num_rounds + 1)
    bowler.update_attribute(:avg_score, (bowler.avg_score + params[:score].to_f) / bowler.num_rounds)
    if bowler.save
      redirect_to '/bowlers'
    else
      flash[:danger] = "oops there was an issue"
      redirect_to cases_path
    end
  end
end
