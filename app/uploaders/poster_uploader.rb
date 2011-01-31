require 'carrierwave/orm/mongoid'

class PosterUploader < CarrierWave::Uploader::Base
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

end
