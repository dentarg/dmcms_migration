require "sinatra/base"
require "sinatra/reloader"
require "haml"
require "redcarpet"

require_relative "models"

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  set :layout, true

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
    content_type @image.type
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

  get '/events_list' do
    events = Event.all.sort { |y,x| x.timestamp <=> y.timestamp }
    events.select! { |event| event.published? }

    @events = events
    haml :events_list
  end

  get '/event/:id' do |id|
    @event = Event[id]
    haml :event
  end

  get '/news/:id' do |id|
    @news = News[id]

    if params['clean']
      haml :single_news_clean
    elsif params['unclean']
      haml :single_news_unclean
    elsif params['md']
      haml :single_news_clean_md
    end
  end

  get '/news_list' do
    @news = News.order(:news_timestamp).reverse
    haml :news_list
  end

  get '/news' do
    @news = News.order(:news_timestamp).reverse
    haml :news
  end

  get '/news_cleaned' do
    @news = News.order(:news_timestamp).reverse
    haml :news_cleaned
  end
end
