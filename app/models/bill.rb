class Bill
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :amount, :category, :create_timestamp, :date, :id, :is_expense, :note, :username

  def initialize(args = {})
    args.each do |key, value|
      public_send("#{key}=", value) if respond_to? "#{key}="
    end
  end

end