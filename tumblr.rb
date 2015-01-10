require "tumblr_client"

Tumblr.configure do |config|
  config.consumer_key =       ENV.fetch("consumer_key")
  config.consumer_secret =    ENV.fetch("consumer_secret")
  config.oauth_token =        ENV.fetch("oauth_token")
  config.oauth_token_secret = ENV.fetch("oauth_token_secret")
end

class TumblrClient
  def self.client
    @@client ||= Tumblr::Client.new
  end

  def self.blog_name
    ENV.fetch('blog_name')
  end

  def self.create_post(type, opts)
    client.create_post(type, blog_name, opts)
  end

  def self.delete(id)
    client.delete(blog_name, id)
  end
end
