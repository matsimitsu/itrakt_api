require 'carrierwave/orm/mongoid'

class BannerUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :iphone_retina do
    process :resize_to_fill => [640, 118]
  end

  version :iphone do
    process :resize_to_fill => [320, 59]
  end


end
