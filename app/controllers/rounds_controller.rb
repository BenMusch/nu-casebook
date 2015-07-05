class RoundsController < ApplicationController
  before_action :logged_in_user

  def new
    @case_options = Case.all.map{ |c| [ c.title, c.id ] }
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
      @case_options = Case.all.map{ |c| [ c.title, c.id ] }
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

  def destory
  end

  private
    def round_params
      params[:win] = params[:win] == '1'
      params.require(:round).permit(:case_id, :speaks, :win, :rfd)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "You must be logged in to view this page"
        redirect_to login_url
      end
    end
end
