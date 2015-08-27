class RdsClient

  def initialize
    @rds = RdsConnection.new
  end

  def save(bill)
    @rds.exec(create_bill_query(bill))
  end

  def get_user_bills(username, start_time=nil, end_time=nil)
    if start_time.nil? || end_time.nil?
      to_bill(@rds.exec(get_all_bills_by_user(username)))
    else
      to_bill(@rds.exec(get_user_bills_by_time_range_query(username, start_time, end_time)))
    end
  end

  def create_bill_query(bill)
    "
    INSERT INTO 
      bills (
        bill_id,
        amount,
        category,
        create_timestamp,
        date,
        is_expense,
        is_deleted,
        username,
        note
      )
    VALUES (
      '#{bill.bill_id}',
      '#{bill.amount}',
      '#{bill.category}',
      '#{bill.create_timestamp}',
      '#{bill.date}',
      '#{bill.is_expense}',
      '#{bill.is_deleted}',
      '#{bill.username}',
      '#{bill.note}'
    )
    "
  end

  def get_user_bills_by_time_range_query(username, start_time, end_time)
    "
    SELECT
    *
    FROM bills
    WHERE
    bills.username = '#{username}' AND
    bills.date BETWEEN '#{start_time}' AND '#{end_time}';
    "
  end

  def get_all_bills_by_user(username)
    "
    SELECT
    *
    FROM bills
    WHERE
    bills.username = '#{username}';
    "
  end

  def to_bill(bills)
    bills.collect { |bill|
      Bill.new(
        bill_id: bill["bill_id"],
        amount: bill["amount"].to_f,
        category: bill["category"],
        create_timestamp: bill["create_timestamp"],
        date: bill["date"],
        is_expense: bill["is_expense"] == 't',
        is_deleted: bill["is_deleted"] == 't',
        username: bill["username"],
        note: bill["note"]
      )
    }
  end
end