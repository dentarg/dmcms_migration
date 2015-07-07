require_relative "tumblr"
require_relative "models"

def post_ids(blog_name)
  number_of_posts = TumblrClient.client.info["user"]["blogs"].find { |blog| blog["name"] == blog_name }["posts"]
  0.step(by: 21, to: number_of_posts).flat_map do |offset|
    posts = TumblrClient.client.posts(blog_name, offset: offset)
    posts["posts"].map { |post| post["id"] }
  end
end

blog_name = ENV.fetch("blog_name")

puts "Getting post IDs from #{blog_name}..."

posts_to_remove = post_ids(blog_name)

puts "Removing #{posts_to_remove.count} posts from #{blog_name}..."

posts_to_remove.each do |id|
  puts TumblrClient.delete_from(blog_name, id)
  log = TumblrLog.find(blog_name: blog_name, tumblr_id: id)
  log && log.destroy
end
