module SessionsHelper

  # Logs the user in
  def log_in(user)
    session[:user_id] = user.id
  end

  # Logs out the current user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Returns the logged-in user, if any
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user
        if user.authenticated?(:remember, cookies[:remember_token])
          log_in user
          @current_user = user
        end
      end
    end
  end

  # Is the current user logged in?
  def logged_in?
    !current_user.nil?
  end

  # Remembers the passed user in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Forgets the user
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Redirects to the previous page, if it exists
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the url trying to be accessed
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  # Forces a login for protected pages
  def force_login
    unless logged_in?
      store_location
      flash[:danger] = "You must be logged in to see this page"
      redirect_to login_url
    end
  end
end
