class SearchesController < ApplicationController
  def create
    @search = Search.new(search_params)
    if @search.save
      redirect_to @search
    else
      render 'cases/index'
    end
  end

  def show
    @search = Search.find(params[:id])
  end

  private

    def search_params
      params.require(:search).permit(:min_speaks,        :min_wins,
                                     :min_tight_call,    :keywords,
                                     :including_topics,  :excluding_topics,
                                     :excluding_viewers, :max_tight_call)
end
