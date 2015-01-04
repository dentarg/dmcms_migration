require_relative "models"
require_relative "tumblr_log"

logged_events = TumblrLog.where(dmcms_type: "event").where(:tumblr_id).all

logged_events.sort! { |x, y| y.event.when_ <=> x.event.when_  }

File.open("events.html", "wt") do |file|
  file.puts "<ul>"
  logged_events.each do |logged_event|
    file.puts "<li><a href='#{logged_event.url}'>#{logged_event.event}</a></li>"
  end
  file.puts "</ul>"
end

# File.open("events.md", "wt") do |file|
#   logged_events.each do |logged_event|
#     file.puts "[#{logged_event.event}](#{logged_event.url})"
#   end
# end
