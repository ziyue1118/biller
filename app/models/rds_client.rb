class RdsClient

  def initialize
    @rds = RdsConnection.new
  end

  def save(bill)
    @rds.exec(create_bill_query(bill))
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
      '#{bill.id}',
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
end