class BillSearch
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :start_time, :end_time, :page, :num_of_pages

  PAGE_SIZE = 15

  def initialize(args = {})
    @start_time = args[:start_time]
    @end_time   = args[:end_time]
    @page       = args.has_key?(:page) ? args[:page].to_i : 0
  end

  def retrieve_bills
    rds = RdsClient.new
    bills = rds.get_user_bills('ziyuchen', @start_time, @end_time)
    @num_of_pages = bills.size / PAGE_SIZE + 1
    # Get the bills on page x:
    bills = bills[@page * 15..@page * 15 + PAGE_SIZE - 1] || []
    bills
  end

end