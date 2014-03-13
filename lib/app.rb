require "bundler"
Bundler.setup(:default)
require "sinatra"
require "sinatra/reloader"

class ShortUrlApp < Sinatra::Base
  set :views, ["templates"]

  get "/" do
    haml :index
  end

  post "/parse" do
    ShortUrl.parse(params[:long_url]).short_url
  end

  get "/:token" do
    su = ShortUrl.parse("#{ShortUrl::BASE_URL}#{params[:token]}")
    return 404 if su.long_url.nil? 
    redirect to(su.long_url)
  end
end
