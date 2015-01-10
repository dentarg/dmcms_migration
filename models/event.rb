# [:event_id, :event_timestamp, :event_name, :event_shorttext, :event_text, :event_place, :event_when, :event_published, :event_image]
class Event < Sequel::Model
  def id
    event_id
  end

  def timestamp
    timestamp = Time.at(event_timestamp)
    timestamp = Time.at(event_when) if timestamp.year < 2006
    timestamp
  end

  def images
    Image.where(image_related: event_id)
  end

  def name
    event_name.to_s.force_encoding(Encoding::UTF_8)
  end

  def shorttext
    event_shorttext.to_s.force_encoding(Encoding::UTF_8)
  end

  def text
    event_text.to_s.force_encoding(Encoding::UTF_8)
  end

  def place
    event_place.to_s.force_encoding(Encoding::UTF_8)
  end

  def when_
    Time.at(event_when).strftime("%Y-%m-%d")
  end

  def to_s
    "#{when_} - #{name}"
  end

  def published?
    event_published == 1
  end

  def image
    Image[event_image]
  end

  def image?
    !image.nil?
  end

  def all_images
    all_images = images.map(&:path)
    all_images << image.path if image
    all_images
  end

  def tumblr_type
    :photo
  end

  def caption
    caption = <<-EOS
    <h1>#{name}</h1>
    <p>#{place} - #{when_}</p>
    <h4>#{shorttext}</h4>
    <p>#{text}</p>
    EOS
  end

  def to_tumblr
    if published?
      log = TumblrLog.create({
        dmcms_id: id,
        dmcms_type: :event,
        tumblr_type: tumblr_type,
        timestamp: Time.now,
        blog_name: TumblrClient.blog_name,
      })

      opts = {
        data: all_images,
        date: timestamp,
        tags: "events, DMCMS#{id}",
        caption: caption,
      }

      tumblr_response = TumblrClient.create_post(tumblr_type, opts)
      tumblr_id = tumblr_response.fetch("id") { nil }

      unless tumblr_id
        puts "ERROR: No Tumblr ID for event #{id}"
        puts
        require 'pp'
        pp tumblr_response
        puts
      end

      log.tumblr_id = tumblr_id
      log.save
    end
  end
end
