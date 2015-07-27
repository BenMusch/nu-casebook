class RoundsController < ApplicationController
  before_action :logged_in_user

  def new
    id = params[:case_id]
    unless id
      flash[:danger] = "You must pick a case before trying to log a round"
      redirect_to 'pick_case'
    end
    @case = Case.find(id)
    @side_options = @case.sides.map { |s| [s.name, s.id] }
    @round = Round.new
  end

  def index
    @case = Case.find(params[:case_id])
    @rounds = @case.rounds.order("created_at DESC")
    @rounds = @rounds.paginate(page: params[:page], per_page: 25)
  end

  def update
    @round = Round.find(params[:id])
    if @case.update_attributes(case_params)
      flash[:success] = "Case updated"
      redirect_to @round
    else
      @case = Case.find(params[:case_id])
      render 'edit'
    end
  end

  def edit
    @round = Round.find(params[:id])
    @case = Case.find(params[:case_id])
    @side_options = @case.sides.map { |s| [s.name, s.id] }
  end

  def get_case
    id = params[:case_id]
    if id
      redirect_to new_case_round_path(case_id: id)
    else
      flash[:danger] = "An error occured. Please try again"
      redirect_to pick_case_path
    end
  end

  def create
    @round = Round.new(round_params)
    if @round.save
      flash[:success] = "Round added"
      redirect_to case_path(id: @round.case_id)
    else
      @case = Case.find(params[:case_id])
      @side_options = @case.sides.map { |s| [s.name, s.id] }
      render 'new'
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
    round = Round.find(params[:id])
    id = round.case.id
    round.destroy
    flash[:success] = "Round deleted"
    redirect_to case_rounds_path(case_id: id)
  end

  private
    def round_params
      params[:win] = params[:win] == '1'
      params[:tight_call] = params[:tight_call] == '1'
      params.require(:round).permit(:case_id, :speaks, :win, :rfd,
                                    :viewers_list, :tight_call, :side_id)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "You must be logged in to view this page"
        redirect_to login_url
      end
    end
end
