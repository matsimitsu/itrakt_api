require 'carrierwave/orm/mongoid'

class PosterUploader < CarrierWave::Uploader::Base
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

end
