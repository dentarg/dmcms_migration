require "sinatra/base"
require "sinatra/reloader"
require "haml"

require_relative "models"

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/bands' do
  end

  get '/comments' do
  end

  get '/image/:id' do |id|
    @image = Image[id]
    body @image.image_data
  end

  get '/image.php' do
    id = params["id"]
    @image = Image[id]
    halt 200 unless @image
    body @image.image_data
  end

  get '/image_thumb/:id' do |id|
    @image = Image[id]
    body @image.image_thumb
  end

  get '/images' do
    @images = Image.all
    haml :images
  end

  get '/events' do
    @events = Event.all
    haml :events
  end

  get '/events2' do
    @events = Event.all.select { |e| e.published? }
    haml :events2
  end

  get '/news' do
    @news = News.all
    haml :news
  end
end
