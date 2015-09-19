class BillSearchesController < ApplicationController

  before_filter :authenticate_user, :only => [:new]

  def new
    @bill_search = BillSearch.new(params)
  
    @bills = @bill_search.retrieve_bills(@current_user)
    @balance = BillAnalyzer.calculate_balance(@bills)
    @bills_hash = @bills.collect { |bill| bill.to_hash }

    respond_to do |format|
      format.html
      format.json { render json: JSON.pretty_generate({ bills: @bills_hash, balance: @balance}) }
    end
  end
end