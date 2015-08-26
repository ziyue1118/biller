class TimestampFormatter

  def self.convert(time)
    time.to_formatted_s(:db)
  end

end