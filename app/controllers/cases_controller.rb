class CasesController < ApplicationController
  before_action :logged_in_user

  def new
    @case = Case.new
  end

  def create
    @case = Case.new(case_params)
    if @case.save
      flash[:success] = "Case created successfully"
      redirect_to @case
    else
      render 'new'
    end
  end

  def edit
    @case = Case.find(params[:id])
  end

  def update
    @case = Case.find(params[:id])
    if @case.update_attributes(case_params)
      flash[:success] = "Case updated"
      redirect_to @case
    else
      render 'edit'
    end
  end

  def show
    @case = Case.find(params[:id])
  end

  def index
    @cases = Case.all.paginate(per_page: 15, page: params[:page])
  end

  def destroy
    Case.find(params[:id]).destroy
    flash[:success] = "Case deleted"
    redirect_to cases_path
  end

  private
    def case_params
      params[:opp_choice] = params[:opp_choice] == '1'
      params.require(:case).permit(:link, :case_statement, :title, :opp_choice)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "You must be logged in to view this page"
        redirect_to login_url
      end
    end
end
