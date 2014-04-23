require "bundler"
Bundler.setup(:default)
require "pry"
require "mongoid"
require "sinatra"
require "rqrcode_png"
require "oily_png"

Mongoid.load!("./config/mongoid.yml")
