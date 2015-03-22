require "nokogiri"

require_relative "image"
require_relative "../helpers/clean"

# [:news_id, :news_timestamp, :news_heading, :news_text, :news_related, :news_published]
class News < Sequel::Model
  def id
    news_id
  end

  def when_
    Time.at(news_timestamp).strftime("%Y-%m-%d")
  end

  def timestamp
    Time.at(news_timestamp)
  end

  def heading
    news_heading.to_s.force_encoding(Encoding::UTF_8)
  end

  def text
    news_text.to_s.force_encoding(Encoding::UTF_8)
  end

  def cleaned_text
    Clean.text(text)
  end

  def published?
    news_published == 1
  end

  def image
    match = text.match(/image.php\?id=(?<id>\d+)/)
    image_id = match[:id] if match
    Image[image_id]
  end

  def image?
    !image.nil?
  end

  def images
    doc = Nokogiri::HTML(text)
    image_paths = doc.css("img").map { |img| img.attributes["src"].value }

    image_ids = image_paths.map do |path|
      match = path.match(/image.php\?id=(?<id>\d+)/)
      image_id = match[:id] if match
    end.compact

    image_ids.map { |id| Image[id.to_i] }.compact
  end

  def images?
    images.any?
  end

  def all_images
    images.map(&:path)
  end

  def caption
    caption = <<-EOS
    <h1>#{heading}</h1>
    <p>#{cleaned_text}</p>
    EOS
  end

  def to_tumblr

    if image
      tumblr_type = :photo
      opts = {
        data: all_images,
        date: timestamp,
        tags: "news, DMCMS#{id}",
        caption: caption,
      }
    else
      tumblr_type = :text
      opts = {
        title: heading,
        body: cleaned_text,
        date: timestamp,
        tags: "news, DMCMS#{id}",
      }
    end

    puts "Uploading news #{id} to Tumlbr... (#{tumblr_type})"

    if published?
      log = TumblrLog.create({
        dmcms_id: id,
        dmcms_type: :news,
        tumblr_type: tumblr_type,
        timestamp: Time.now,
        blog_name: TumblrClient.blog_name,
      })

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
