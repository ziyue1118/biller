require 'securerandom'

class BillsController < ApplicationController

  def index
    # Should show all the bills you have
  end

  def create
    bill = Bill.new(params[:bill].merge!({id: SecureRandom.uuid, create_timestamp: Time.now.utc}))
    flash[:success] = "Successfully created a Bill!!"
    redirect_to bills_path
  end

  def new
    @bill = Bill.new
  end

end