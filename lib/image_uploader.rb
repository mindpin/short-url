class ImageUploader < CarrierWave::Uploader::Base
  storage :aliyun

  def filename
    "#{self.model.token}.png"
  end

  def store_dir
    File.join(R::ALIYUN_BASE_DIR)
  end

  def cache_dir
    "/tmp/qr"
  end
end
