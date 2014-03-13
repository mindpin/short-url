require "uri"
require "./config/env"

class ShortUrl
  BASE_URL = "http://s.4ye.me/"
  SHORT_URL_REGEX = Regexp.new(%Q{^#{BASE_URL.gsub("/", "\\/")}(\\w*)$})

  include Mongoid::Document
  include Mongoid::Timestamps

  field :long_url, type: String
  field :token,    type: String

  validates :token,    uniqueness: true
  validates :long_url, uniqueness: true

  validates :token,    presence: true
  validates :long_url, presence: true

  validates :long_url, format: {
    with: URI::regexp(%w(http https))
  }

  def self.parse(url)
    return ShortUrl.find_or_initialize_by(token: $1) if SHORT_URL_REGEX.match(url)
    self.find_or_create_by(long_url: url)
  end

  alias :"old_token=" :"token="
  alias :"old_long="  :"long_url="

  def long_url=(url)
    self.token ||= randstr
    self.old_long = url
  end

  def token=(token)
    return self.old_token = token if ShortUrl.where(token: token).size == 0
    self.token = randstr
  end

  def short_url
    "#{BASE_URL}#{self.token}"
  end

  private

  def randstr(length=6)
    base = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    size = base.size
    re = '' << base[rand(size-10)]
    (length - 1).times {
      re << base[rand(size)]
    }
    re
  end
end
