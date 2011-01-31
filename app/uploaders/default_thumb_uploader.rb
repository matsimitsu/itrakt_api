require 'carrierwave/orm/mongoid'

class DefaultThumbUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.tvdb_id}"
  end

  def filename
    if original_filename
      extension = File.extname(file.file)
      "#{mounted_as}-#{model.tvdb_id}#{extension}"
    end
  end

  process :resize_to_fit => [400,228]

  version :original do
  end

end
