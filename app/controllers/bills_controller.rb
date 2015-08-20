class BillsController < ApplicationController

  def index
    # Should show all the bills you have 
  end

  def create

  end

  def new
    @bill = Bill.new
  end


end