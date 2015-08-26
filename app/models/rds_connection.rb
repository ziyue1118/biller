require 'pg'

class RdsConnection
  attr_accessor :conn

  def initialize
    if @conn.nil?
      @conn = PG::Connection.new(
        dbname: APP_CONFIG['db_name'],
        host: APP_CONFIG['rds_endpoint'],
        port: APP_CONFIG['port'],
        user: APP_CONFIG['username'],
        password: APP_CONFIG['password']
      )
    end
  end

  def exec(query)
    results = []
    @conn.exec(query) do |rs_results|
      rs_results.each do |row|
        results << row
      end
    end
    trim_query_result(results)
  end

  def trim_query_result(results)
    unless results.empty?
      results.each do |result|
        result.keys.each do |key|
          result[key] = result[key].strip if result[key].kind_of? String
        end
      end
    end
  end
end