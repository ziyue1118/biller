class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def authenticate_user
    if session[:username]
       # set current user object to @current_user object variable
      @current_user = session[:username]
      return true
    else
      redirect_to(:controller => 'sessions', :action => 'login')
      return false
    end
  end

  def save_login_state
    if session[:username]
      redirect_to(:controller => 'bills', :action => 'index')
      return false
    else
      return true
    end
  end
end
