class RdsClient

  def initialize
    @rds = RdsConnection.new
  end

  def close_connection
    @rds.close_connection
  end

  def save(bill)
    @rds.exec(create_bill_query(bill))
  end

  def get_user_bills(username, start_time=nil, end_time=nil)
    if start_time.nil? || end_time.nil? || start_time == "" || end_time == ""
      to_bill(@rds.exec(get_all_bills_by_user_query(username)))
    else
      to_bill(@rds.exec(get_user_bills_by_time_range_query(username, start_time, end_time)))
    end
  end

  def get_user_bill_by_id(bill_id)
    bills = @rds.exec(get_user_bill_by_id_query(bill_id))
    to_bill(bills)
  end

  def update_bill(bill)
    @rds.exec(update_user_bill_query(bill))
  end

  def create_user(user)
    @rds.exec(create_user_query(user))
  end

  def get_user_by_username(username)
    to_user(@rds.exec(get_user_by_username_query(username)))
  end

  def get_user_by_email(email)
    to_user(@rds.exec(get_user_by_email_query(email)))
  end

  def get_all_usernames
    @rds.exec(get_all_usernames_query()).collect { |user| user["username"] }
  end

  def to_bill(bills)
    if bills.nil?
      []
    else
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

  def to_user(users)
    if users.nil?
      nil
    else
      users.collect { |user|
        User.new(
          username: user["username"],
          email: user["email"],
          password: user["password"]
        )
      }
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
    bills.date BETWEEN '#{start_time}' AND '#{end_time}'
    ORDER BY
    date;
    "
  end

  def get_all_bills_by_user_query(username)
    "
    SELECT
    *
    FROM bills
    WHERE
    bills.username = '#{username}'
    ORDER BY
    date;
    "
  end

  def get_user_bill_by_id_query(bill_id)
    "
    SELECT
    *
    FROM bills
    WHERE
    bills.bill_id = '#{bill_id}';
    "
  end

  def update_user_bill_query(bill)
    "
    UPDATE
      bills
    SET
      amount = '#{bill.amount}',
      category = '#{bill.category}',
      date = '#{bill.date}',
      is_expense = '#{bill.is_expense}',
      note = '#{bill.note}'
    WHERE
      bills.bill_id = '#{bill.bill_id}';
    "
  end


  def get_user_by_username_query(username)
    "
    SELECT
    *
    FROM users
    WHERE
    users.username = '#{username}';
    "
  end


  def get_user_by_email_query(email)
    "
    SELECT
    *
    FROM users
    WHERE
    users.email = '#{email}';
    "
  end

  def create_user_query(user)
    "
    INSERT INTO
      users (
        username,
        email,
        password
      )
    VALUES (
      '#{user.username}',
      '#{user.email}',
      '#{user.password}'
    );
    "
  end

  def get_all_usernames_query
    "
    SELECT
      username
    FROM users
    GROUP BY username;
    "
  end

end