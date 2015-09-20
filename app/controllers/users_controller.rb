require 'digest'

class UsersController < ApplicationController

  def create
    params[:user][:password] = Digest::SHA256.hexdigest(params[:password])
    user = User.new(params[:user])
    puts user.username
    puts user.email
    puts user.password

    rds = RdsClient.new
    rds.create_user(user)
    # redirect_to bills_path
  end

  def is_username_available(username)
  end

end