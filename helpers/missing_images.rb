require_relative "../models"

# news_id filename event_id
MISSING_IMAGES = [
  [20258, "col.jpg",   10206],
  [20266, "dante.png", 10211],
  [20265, "zhala.png", 10209],
]

MISSING_IMAGES_PATH = ENV.fetch("missing_images_path")

def fix_missing_image(news_id, filename, event_id)
  news = News[news_id]
  file = File.open(File.join("#{MISSING_IMAGES_PATH}", filename))

  # image = Image.new
  # image.image_timestamp = news.news_timestamp
  # image.image_data = Sequel.blob(file.read)
  # image.image_size = file.size
  # image.image_name = filename
  # image.image_related = event_id
  # image.image_type = "application/octet-stream"
  # image.save

  sql =
    "INSERT INTO `images` VALUES (" <<
    "NULL, "                        << # id
    "#{news.news_timestamp},"       << # timestamp
    "'application/octet-stream',"   << # type
    "'replace me',"                 << # data
    "'#{file.size}',"               << # size
    "'#{filename}',"                << # name
    "'',"                           << # text
    "#{event_id},"                  << # related
    "''"                            << # thumb
    ");"

  DB.run sql
end

MISSING_IMAGES.each do |row|
  image = fix_missing_image *row
  puts "Saved Image id=#{Image.last.id} name=#{row[1]}"
end
