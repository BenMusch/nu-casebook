class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def index
    if logged_in?
      redirect_to cases_url
    else
      render 'static_pages/index'
    end
  end
end
