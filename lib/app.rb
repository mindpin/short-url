require "bundler"
require "./lib/short_url"
Bundler.setup(:default)
require "sinatra"
require "sinatra/reloader"
require 'haml'

class ShortUrlApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  set :views, ["templates"]

  get "/" do
    haml :index
  end

  post "/parse" do
    @long_url = params[:long_url]
    @short_url = ShortUrl.parse(params[:long_url]).short_url
    haml :index
  end

  get "/:token" do
    su = ShortUrl.parse("#{ShortUrl::BASE_URL}#{params[:token]}")
    return 404 if su.long_url.nil? 
    redirect to(su.long_url)
  end
end
