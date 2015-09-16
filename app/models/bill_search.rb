class BillSearch
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :start, :end

  PAGE_SIZE = 15

  def initialize(args = {})
    @start = args[:start]
    @end   = args[:end]
  end

  def retrieve_bills
    rds = RdsClient.new
    bills = rds.get_user_bills('ziyuchen', @start, @end)
    # @num_of_pages = bills.size / PAGE_SIZE + 1
    # # Get the bills on page x:
    # bills = bills[@page * 15..@page * 15 + PAGE_SIZE - 1] || []
    bills
  end

end