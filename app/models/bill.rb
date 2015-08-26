class Bill
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :amount, :category, :create_timestamp, :date, :id, :is_expense, :is_deleted, :note, :username

  def initialize(args = {})
    args.each do |key, value|
      public_send("#{key}=", value) if respond_to? "#{key}="
    end

    @create_timestamp = TimestampFormatter.convert(@create_timestamp) unless @create_timestamp.nil?
    @amount = @amount.to_f unless @amount.nil?
  end
end