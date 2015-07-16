class TopicsController < ApplicationController
  def index
    @topics = Topic.all
    respond_to do |format|
      format.json { render json: @topics.tokens(params[:q])) }
    end
  end
end
