class BillSearchesController < ApplicationController
  def new
    if params[:bill_search]
      @bill_search = BillSearch.new(params[:bill_search])
    else
      @bill_search = BillSearch.new
    end
    @bills = @bill_search.retrieve_bills
    @balance = BillAnalyzer.calculate_balance(@bills)
  end
end