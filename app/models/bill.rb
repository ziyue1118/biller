class Bill
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :amount, :category, :create_timestamp, :date, :is_expense, :note

  def initialize(args = {})
    args.each do |key, value|
      public_send("#{key}=", value) if respond_to? "#{key}="
    end
  end

end