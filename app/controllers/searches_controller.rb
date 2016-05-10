class SearchesController < ApplicationController
  before_action :logged_in_user

  def create
    @search = Search.new(search_params)
    if @search.save
      redirect_to @search
    else
      render 'cases/index'
    end
  end

  def update
    @search = Search.find(params[:id])
    if @search.update_attributes(search_params)
      redirect_to @search
    else
      render 'cases/index'
    end
  end

  def show
    @search = Search.find(params[:id])
    @cases = @search.search_cases
    visibility = current_user.full_access? ? 1 : 2
    if current_user.id == 30 || current_user.id == 27
      @cases = @cases.where("user_id in (27, 30) or visibility >= ?", visibility)
    else
      @cases = cases.where("user_id = ? or visibility >= ?", current_user.id, visibility)
    end
    @cases = @cases.paginate(page: params[:page], per_page: 20)
    @cases = @cases.order(params[:sort])
  end

  private

    def search_params
      params.require(:search).permit(:min_speaks,     :min_wins,
                                     :min_tight_call, :including_topics_list,
                                     :keywords,       :excluding_topics_list,
                                     :max_tight_call, :excluding_viewers_list)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "You must be logged in to view this page"
        redirect_to login_url
      end
    end
end
