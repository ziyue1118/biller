class BillAnalyzer

  def self.calculate_balance(bills)
    not_deleted_bills = bills.select { |bill| !bill.is_deleted }
    balance = 0
    not_deleted_bills.each do |bill|
      if bill.is_expense
        balance -= bill.amount
      else
        balance += bill.amount
      end
    end
    balance
  end

  #Return a hash that looks like:
  #{'2015-07-28': { bills: bills_happened_on_key_day, balance: -40.0}}
  def self.sort_bills_by_date(bills)
    time_to_bills = {}
    bills.each do |bill|
      key = Time.parse(bill.date).strftime "%Y-%m-%d"
      if time_to_bills[key].nil?
        time_to_bills[key] = { bills: [bill] }
      else
        time_to_bills[key][:bills] << bill
      end
    end

    time_to_bills.each do |key, bills_hash|
      bill_ids = bills_hash[:bills].collect { |bill| bill.bill_id }
      time_to_bills[key] = bills_hash.merge!({ bills: bill_ids, balance: calculate_balance(bills_hash[:bills]), count: bills_hash[:bills].size})
    end
    time_to_bills
  end
end