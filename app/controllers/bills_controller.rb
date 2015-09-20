require 'securerandom'

class BillsController < ApplicationController

  before_filter :authenticate_user, :only => [:new, :index, :create, :show, :edit, :update]

  def index
    rds = RdsClient.new

    #TODO: change the hard-code username to be the login username.
    bills = rds.get_user_bills(@current_user, params[:start], params[:end])

    # Should show all the bills you have for given time range
    @bills_by_time = BillAnalyzer.sort_bills_by_date(bills)

    respond_to do |format|
      format.html
      format.json { render json: JSON.pretty_generate(@bills_by_time) }
    end
  end

  def create
    bill = Bill.new(params[:bill].merge!({
      bill_id: SecureRandom.uuid,
      create_timestamp: Time.now,
      is_deleted: false,
      username: @current_user
    }))

    rds = RdsClient.new
    rds.save(bill)

    flash[:success] = "Successfully created a Bill!!"

    redirect_to bills_path
  end

  def new
    @bill = Bill.new
  end

  def show
    rds = RdsClient.new
    bills = rds.get_user_bill_by_id(params[:id])

    if bills.empty?
      flash[:danger] = "There is no bill with #{params[:id]}"
      redirect_to bills_path
    else
      @bill = bills[0]
      respond_to do |format|
        format.html
        format.json { render json: JSON.pretty_generate(bill: @bill.to_hash) }
      end
    end
  end

  def edit
    rds = RdsClient.new
    bills = rds.get_user_bill_by_id(params[:id])

    if bills.empty?
      flash[:danger] = "There is no bill with #{params[:id]}"
      redirect_to bills_path
    else
      @bill = bills[0]
    end
  end

  def update
    bill = Bill.new(params[:bill].merge!({
      bill_id: params[:id]
    }))

    rds = RdsClient.new
    rds.update_bill(bill)
    flash[:success] = "Finish updating the bill"
    redirect_to bill_path
  end

end