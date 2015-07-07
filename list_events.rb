require_relative "models"
require_relative "tumblr_log"

events = Event.all.sort { |y,x| x.event_when <=> y.event_when }
events.select! { |event| event.published? }

File.open("events.html", "wt") do |file|
  file.puts "<ul>"
  events.each do |event|
    file.puts "<li>#{event}</li>"
  end
  file.puts "</ul>"
end
