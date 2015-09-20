class BillSearch
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :start, :end

  PAGE_SIZE = 15

  def initialize(args = {})
    @start = args[:start]
    @end   = args[:end]
  end

  def retrieve_bills(username)
    rds = RdsClient.new
    bills = rds.get_user_bills(username, @start, @end)
    rds.close_connection
    bills
  end

end