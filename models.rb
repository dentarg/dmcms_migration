require_relative "tumblr"
require_relative "db_connect"
require_relative "tumblr_log"

class Band < Sequel::Model
end

class Comment < Sequel::Model
end

require_relative "models/image"
require_relative "models/event"
require_relative "models/news"
