require "sequel"

DB ||= Sequel.connect(ENV.fetch('database_url'))

# require "logger"
# DB.loggers << Logger.new($stdout)
