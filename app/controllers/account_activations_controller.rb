class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by_email(params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Activation successful!"
      redirect_to root_url
    else
      flash[:danger] = "Invalid validation link"
      redirect_to root_url
    end
  end
end
