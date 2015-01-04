DB.create_table?(:tumblr_logs) do
  primary_key :id
  String :dmcms_id
  String :dmcms_type  # Image, Event, News
  String :tumblr_id
  String :tumblr_type # Photo(s), Text
  DateTime :timestamp
end

require_relative "models/event"
require_relative "models/news"

class TumblrLog < Sequel::Model
  def event?
    dmcms_type == "event"
  end

  def event
    Event[dmcms_id] if event?
  end

  def news?
    dmcms_type == "news"
  end

  def news
    News[dmcms_id] if news?
  end

  def url
    "/post/#{tumblr_id}"
  end
end
