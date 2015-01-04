require_relative "models"
require_relative "tumblr_log"

Event.all.each do |event|
  unless event.published?
    puts "Skipping event #{event.id}, not published"
    next
  end

  logs = TumblrLog.where(dmcms_type: "event", dmcms_id: event.id)

  if logs.any? { |log| log.tumblr_id }
    tumblr_id = logs.map(&:tumblr_id).compact.first
    puts "Skipping event #{event.id}, already has Tumblr ID #{tumblr_id}"
  else
    puts "Uploading event #{event.id} to Tumlbr..."
    event.to_tumblr
  end
end
