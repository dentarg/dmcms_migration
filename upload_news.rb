require_relative "models"
require_relative "tumblr_log"

News.all.each do |news|
  unless news.published?
    puts "Skipping news #{news.id}, not published"
    next
  end

  logs = TumblrLog.where(dmcms_type: "news", dmcms_id: news.id)

  if logs.any? { |log| log.tumblr_id }
    tumblr_id = logs.map(&:tumblr_id).compact.first
    puts "Skipping news #{news.id}, already has Tumblr ID #{tumblr_id}"
  else
    news.to_tumblr
  end
end
