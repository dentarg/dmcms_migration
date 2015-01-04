require "sequel"

DB ||= Sequel.connect(ENV.fetch('database_url'))
