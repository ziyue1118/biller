class BillSearchesController < ApplicationController
  def new
    @bill_search = BillSearch.new(params)
  
    @bills = @bill_search.retrieve_bills("ziyuchen")
    @balance = BillAnalyzer.calculate_balance(@bills)
    @bills_hash = @bills.collect { |bill| bill.to_hash }

    respond_to do |format|
      format.html
      format.json { render json: JSON.pretty_generate({ bills: @bills_hash, balance: @balance}) }
    end
  end
end