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
    ShortUrl.parse(params[:long_url])
  end

  get "/:token" do
    return 404 if params[:token]
  end
end
