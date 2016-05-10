class CasesController < ApplicationController
  before_action :logged_in_user
  before_action :authorized_to_view_case, only: [:edit, :update, :show, :destroy]

  def new
    @case = Case.new
    2.times { @case.sides.build }
  end

  def create
    @case = Case.new(case_params)
    @case.user = current_user
    if @case.save
      flash[:success] = "Case created successfully"
      redirect_to @case
    else
      render 'new'
    end
  end

  def edit
    @case = Case.find(params[:id])
    2.times { @case.sides.build } unless @case.sides.present?
  end

  def update
    @case = Case.find(params[:id])
    if params[:visibility] != @case.visibility && current_user != @case.user
      flash[:danger] = "You cannot change the visibility of a case that isn't yours."
      redirect_to @case
    elsif @case.update_attributes(case_params)
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
    @cases = get_cases
    @cases = @cases.paginate(page: params[:page], per_page: 20)
    @cases = @cases.order(params[:sort] || 'wins + losses desc')
    @search = Search.new
  end

  def destroy
    Case.find(params[:id]).destroy
    flash[:success] = "Case deleted"
    redirect_to cases_path
  end

  private
    def case_params
      params[:opp_choice] = params[:opp_choice] == '1'
      params.require(:case).permit(:link,       :case_statement,
                                   :title,      :opp_choice, :visibility,
                                   :topic_list, sides_attributes: [:name, :id])
    end

    def get_cases
      cases = Case.search(params[:search])
      visibility = current_user.full_access? ? 1 : 2
      if current_user.id == 30 || current_user.id == 27
        cases.where("user_id in (27, 30) or visibility >= ?", visibility)
      else
        cases.where("user_id = ? or visibility >= ?", current_user.id, visibility)
      end
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "You must be logged in to view this page"
        redirect_to login_url
      end
    end

    def authorized_to_view_case
      unless Case.find(params[:id]).can_be_viewed_by?(current_user)
        flash[:danger] = "You are not authorized to see that case"
        redirect_to root_path
      end
    end
end
