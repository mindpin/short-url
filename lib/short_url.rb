class ShortUrl
  BASE_URL = "http://s.4ye.me/"
  SHORT_URL_REGEX = Regexp.new(%Q{^#{BASE_URL.gsub("/", "\\/")}(\\w*)$})

  include Mongoid::Document
  include Mongoid::Timestamps

  field :long_url, type: String
  field :token,    type: String
  field :file,     type: String
  field :qrcode_generated, type: Boolean

  validates :token,    uniqueness: true
  validates :long_url, uniqueness: true

  validates :token,    presence: true
  validates :long_url, presence: true

  validates :long_url, format: {
    with: URI::regexp(%w(http https))
  }

  mount_uploader :file, ImageUploader

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

  after_create :qrcode

  private
  def qrcode
    return if !!self.qrcode_generated

    qrcode!
  end

  def qrcode!
    img = RQRCode::QRCode.new(short_url, :size => 4, :level => :h).to_img
    File.delete(_qrcode_tmepfile) if File.exists?(_qrcode_tmepfile)
    img.resize(120, 120).save(_qrcode_tmepfile)
    self.file = File.new(_qrcode_tmepfile)
    self.qrcode_generated = true
    self.save
  end

  def _qrcode_tmepfile
    "/tmp/#{self.token}.png"
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
