require_relative "tumblr"
require_relative "db_connect"
require_relative "tumblr_log"

TumblrLog.all.each do |log|
  if log.tumblr_id
    puts "Removing #{log.tumblr_id} from Tumblr..."
    TumblrClient.delete(log.tumblr_id)
  end
  log.destroy
end
