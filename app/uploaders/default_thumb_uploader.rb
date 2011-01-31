require 'carrierwave/orm/mongoid'

class DefaultThumbUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}"
  end

  def filename
    if original_filename
      extension = File.extname(file.file)
      "#{model.tvdb_id}#{extension}"
    end
  end

  process :resize_to_fit => [400,228]

  version :original do
  end

end
