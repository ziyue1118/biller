require 'securerandom'

class BillsController < ApplicationController

  def index
    rds = RdsClient.new

    #TODO: change the hard-code username to be the login username.
    bills = rds.get_user_bills('ziyuchen')

    # Should show all the bills you have for given time range
    @bills_by_time = BillAnalyzer.sort_bills_by_date(bills)
  end

  def create
    #TODO: change the hard-code username to be the login username.
    bill = Bill.new(params[:bill].merge!({
      bill_id: SecureRandom.uuid,
      create_timestamp: Time.now,
      is_deleted: false,
      username: "ziyuchen"
    }))

    rds = RdsClient.new
    rds.save(bill)

    flash[:success] = "Successfully created a Bill!!"
    redirect_to bills_path
  end

  def new
    @bill = Bill.new
  end

end