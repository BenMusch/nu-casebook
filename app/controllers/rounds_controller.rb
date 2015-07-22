class RoundsController < ApplicationController
  before_action :logged_in_user

  def new
    unless params[:case_id]
      flash[:danger] = "You must pick a case before trying to log a round"
      redirect_to 'pick_case'
    end
    @case = Case.find(params[:case_id])
    @side_options = @case.sides.map { |s| [s.name, s.id] }
    @round = Round.new
  end

  def edit
    @round = Round.find(params[:id])
  end

  def create
    @round = Round.new(round_params)
    if @round.save
      flash[:success] = "Round added"
      redirect_to case_path(id: @round.case_id)
    else
      redirect_to new_round_path(@round, case_id: @round.case_id)
    end
  end

  def update
    @round = Round.find(params[:id])
    if @round.update_attributes(round_params)
      flash[:success] = "Round updated"
      redirect_to case_path(id: @round.case_id)
    else
      render 'edit'
    end
  end

  def destroy
  end

  private
    def round_params
      params[:win] = params[:win] == '1'
      params[:tight_call] = params[:tight_call] == '1'
      params.require(:round).permit(:case_id, :speaks, :win, :rfd,
                                    :viewers_list, :tight_call)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "You must be logged in to view this page"
        redirect_to login_url
      end
    end
end
