require "bundler"
require "./lib/short_url"
Bundler.setup(:default)
require "sinatra"
require "sinatra/reloader"
require 'haml'
require 'sinatra/assetpack'
require 'sass'
require 'coffee_script'
require 'yui/compressor'

class ShortUrlApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  set :views, ["templates"]
  set :root, File.expand_path("../../", __FILE__)
  register Sinatra::AssetPack

  assets {
    serve '/js', :from => 'assets/javascripts'
    serve '/css', :from => 'assets/stylesheets'

    js :application, "/js/application.js", [
      '/js/**/*.js'
    ]

    css :application, "/css/application.css", [
      '/css/**/*.css'
    ]

    css_compression :yui
  }

  get "/" do
    haml :index
  end

  post "/parse" do
    @short_url = ShortUrl.parse(params[:long_url])
    if @short_url.valid?
      @short_url_str = @short_url.short_url
    else
      @error = "输入的不是一个有效的地址"
    end
    @long_url_str = params[:long_url]
    haml :index
  end

  get "/:token" do
    su = ShortUrl.parse("#{ShortUrl::BASE_URL}#{params[:token]}")
    return 404 if su.long_url.nil? 
    redirect to(su.long_url)
  end
end
