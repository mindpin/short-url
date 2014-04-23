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

  before_save :qrcode!

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

  def qrcode
    qrcode! if !File.exists?("#{qr_store}/#{self.token}.png")
    "/qr_store/#{self.token}.png"
  end

  private

  def qr_store
    "#{ShortUrlApp.settings.public_folder}/qr_store"
  end

  def qrcode!
    img = RQRCode::QRCode.new(short_url, :size => 4, :level => :h).to_img
    FileUtils.mkdir_p(qr_store) if !File.exists?(qr_store)
    img.resize(120, 120).save("#{qr_store}/#{self.token}.png")
  end

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
