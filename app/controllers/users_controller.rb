require 'digest'

class UsersController < ApplicationController

  def create
    params[:user][:password] = Digest::SHA256.hexdigest(params[:password])
    user = User.new(params[:user])

    rds = RdsClient.new
    rds.create_user(user)
    # redirect_to bills_path
  end

  def is_unique_username
    rds = RdsClient.new
    names = rds.get_all_usernames()
    rds.close_connection()

    respond_to do |format|
      format.html
      format.json { render json: JSON.pretty_generate({is_unique_username: !names.include?(params[:username])}) }
    end
  end

end