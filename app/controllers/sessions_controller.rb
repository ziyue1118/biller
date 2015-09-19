class SessionsController < ApplicationController

  before_filter :save_login_state, :only => [:login, :login_attempt]

  def login
  end
  
  def login_attempt
    authorized_user = User.authenticate(params[:username_or_email], params[:password])
    if authorized_user
      session[:username] = authorized_user.username
      flash[:success] = "Welcome again, you logged in as #{authorized_user.username}"
      redirect_to bills_path()
    else
      flash[:danger] = "Sorry the username and password do not match, try again!"
      redirect_to :action => 'login'
    end
  end

  def logout
    session[:username] = nil
    redirect_to :action => 'login'
  end
end