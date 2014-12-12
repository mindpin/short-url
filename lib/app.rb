# coding: utf-8
require "bundler"
Bundler.setup(:default)
require "pry"
require "mongoid"
require "rqrcode_png"
require "oily_png"
require "sinatra"
require "sinatra/reloader"
require 'haml'
require 'sinatra/assetpack'
require 'sass'
require 'coffee_script'
require 'yui/compressor'
require 'sinatra/json'
require "uri"

require 'carrierwave'
require 'carrierwave/mongoid'
require 'carrierwave-aliyun'

require File.expand_path("../../config/env",__FILE__)
require "./lib/image_uploader"
require "./lib/short_url"
require 'logger'

class ShortUrlApp < Sinatra::Base
  ::Logger.class_eval { alias :write :'<<' }
  access_log = ::File.join(::File.dirname(::File.expand_path(__FILE__)),'..','tmp','logs','access.log')
  access_logger = ::Logger.new(access_log)
  error_logger = ::File.new(::File.join(::File.dirname(::File.expand_path(__FILE__)),'..','tmp','logs','error.log'),"a+")
  error_logger.sync = true
 
  configure do
    use ::Rack::CommonLogger, access_logger
  end
 
  before {
    env["rack.errors"] =  error_logger
    headers['Access-Control-Allow-Origin']   = '*'
    headers['Access-Control-Allow-Methods']  = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
  }

  configure :development do
    register Sinatra::Reloader
  end

  set :views, ["templates"]
  set :root, File.expand_path("../../", __FILE__)
  register Sinatra::AssetPack

  assets {
    serve '/js', :from => 'assets/javascripts'
    serve '/css', :from => 'assets/stylesheets'
    serve '/plugin_js', :from => 'assets/plugin_javascripts'

    js :application, "/js/application.js", [
      '/js/jquery-1.11.0.min.js',
      '/js/**/*.js'
    ]

    css :application, "/css/application.css", [
      '/css/**/*.css'
    ]

    css_compression :yui
    js_compression  :uglify
  }

  get "/" do
    haml :index
  end

  post "/parse" do
    @short_url = ShortUrl.parse(params[:long_url])
    if @short_url.valid?
      json :short_url => @short_url.short_url, :long_url => @short_url.long_url, :qrcode => @short_url.qrcode_url
    else
      status 500
      json :error => "输入的不是一个有效的地址"
    end
  end

  get "/:token" do
    su = ShortUrl.parse("#{ShortUrl::BASE_URL}#{params[:token]}")
    return 404 if su.long_url.nil? 
    redirect to(su.long_url), 301
  end
end
