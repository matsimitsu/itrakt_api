require 'carrierwave/orm/mongoid'

class EpisodeThumbUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}"
  end

  def filename
    if original_filename
      extension = File.extname(file.file)
      "#{model.tvdb_id}-#{model.season_number}-#{model.episode_number}#{extension}"
    end
  end

end
