class ViewersController < ApplicationController
  def index
    @viewers = Viewer.all
    respond_to do |format|
      format.json { render json: @viewers.tokens(params[:q]) }
    end
  end
end
