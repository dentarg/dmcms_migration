# [:image_id, :image_timestamp, :image_type, :image_data, :image_size, :image_name, :image_text, :image_related, :image_thumb]
class Image < Sequel::Model
  BASE_PATH = File.expand_path("~/Dropbox/work/klubbdinmamma/dmcms_images")

  def id
    image_id
  end

  def name
    image_name.to_s.force_encoding(Encoding::UTF_8)
  end

  def text
    image_text.to_s.force_encoding(Encoding::UTF_8)
  end

  def path
    extension = name.split(".").last.downcase
    path = File.join(BASE_PATH, "#{id}.#{extension}")

    return path if Pathname.new(path).exist?

    File.open(path, "wb") { |file| file.write(image_data) }

    path
  end

  def text
    text.to_s.force_encoding(Encoding::UTF_8)
  end

  def timestamp
    Time.at(image_timestamp)
  end
end
