class Bill
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :amount, :bill_id, :category, :create_timestamp, :date, :is_expense, :is_deleted, :note, :username

  def initialize(args = {})
    args.each do |key, value|
      public_send("#{key}=", value) if respond_to? "#{key}="
    end

    @create_timestamp = TimestampFormatter.convert(@create_timestamp) if @create_timestamp.kind_of? Time
    @amount = @amount.to_f if @amount.kind_of? String
  end
end