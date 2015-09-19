require 'digest'

class User
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  EMAIL_REGEX = /^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/

  attr_accessor :username, :email, :password

  def initialize(args = {})
    args.each do |key, value|
      public_send("#{key}=", value) if respond_to? "#{key}="
    end
  end

  def persisted?
    false
  end

  def self.authenticate(username_or_email="", password="")
    rds = RdsClient.new

    if EMAIL_REGEX.match(username_or_email)
      users = rds.get_user_by_email(username_or_email)
    else
      users = rds.get_user_by_username(username_or_email)
    end
    if users[0] && users[0].match_password(password)
      return users[0]
    else
      return false
    end
  end

  def match_password(password)
    @password == Digest::SHA256.hexdigest(password)
  end


end