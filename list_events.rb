require_relative "models"
require_relative "tumblr_log"

File.open("events.html", "wt") do |file|
  Event.years_with_events_to_be_listed.each do |year|
    file.puts "<h3>#{year}</h3>"
    file.puts "<ul>"
    events = Event.list_events_from(year: year)
    events.each do |event|
      file.puts "<li>#{event}</li>"
    end
    file.puts "</ul>"
  end
end
