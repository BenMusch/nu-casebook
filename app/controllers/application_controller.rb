class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def index
    if logged_in?
      redirect_to secret_path
    else
      render 'static_pages/index'
    end
  end

  def secret
    if logged_in?
      render 'static_pages/secret'
    else
      force_login
    end
  end
end
