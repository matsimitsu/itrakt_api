class Show
  include Mongoid::Document
  include Mongoid::Timestamps

  API_FIELDS = {
    :overview => 'overview',
    :genres => 'genres',
    :runtime => 'runtime',
    :name => 'name',
    :first_aired => 'first_aired',
    :network => 'network',
    :tvdb_id => 'id',
    :air_time => 'air_time',
    :runtime => 'runtime',
  }

  field :overview
  field :genres, :type => Hash, :default => {}
  field :runtime
  field :name
  field :first_aired, :type => Date
  field :network
  field :tvdb_id
  field :remote_banner_url
  field :remote_poster_url
  field :runtime
  field :air_time

  references_many :episodes

  mount_uploader :banner, BannerUploader
  mount_uploader :poster, PosterUploader
  mount_uploader :default_thumb, DefaultThumbUploader

  def updateable?
    updated_at == nil || updated_at < 1.day.ago || name.blank?
  end

  def poster_url
    poster_filename.present? ? poster.url : '/images/default_poster.jpg'
  end

  def thumb_url
    default_thumb_filename.present? ? default_thumb.url : '/images/default_thumb.jpg'
  end

  def tvdb_reference
    tvdb = TvdbParty::Search.new(Tvdb::API_KEY)
    tvdb.get_series_by_id(tvdb_id)
  end

  class << self

    def find_or_fetch_from_tvdb_id(tvdb_id)
      first(:conditions => { :tvdb_id => tvdb_id }) || create_from_tvdb_id(tvdb_id)
    end

    def create_from_tvdb_id(tvdb_id)
      Rails.logger.info("Requesting show from TVDB: #{tvdb_id}")
      tvdb = TvdbParty::Search.new(Tvdb::API_KEY)
      show = tvdb.get_series_by_id(tvdb_id)

      new_show_data = {}

      API_FIELDS.each do |fld, remote_fld|
        new_show_data[fld] = show.send(remote_fld)
      end

      new_show_data[:remote_banner_url] = show.series_banners('en').first.url rescue nil
      new_show_data[:remote_poster_url] = show.posters('en').first.url rescue nil
      new_show_data[:remote_default_thumb_url] = show.fanart('en').first.url rescue nil

      create(new_show_data)
    end


    def update_or_create_from_tvdb_id(tvdb_id)
      Rails.logger.info("Requesting show from TVDB: #{tvdb_id}")
      show = Show.find_or_create_by(:tvdb_id => tvdb_id)

      tvdb = TvdbParty::Search.new(Tvdb::API_KEY)
      tvdb_show = tvdb.get_series_by_id(tvdb_id)

      new_show_data = {}

      API_FIELDS.each do |fld, remote_fld|
        new_show_data[fld] = tvdb_show.send(remote_fld)
      end

      new_show_data[:remote_banner_url] = tvdb_show.series_banners('en').first.url rescue nil
      new_show_data[:remote_poster_url] = tvdb_show.posters('en').first.url rescue nil
      new_show_data[:remote_default_thumb_url] = tvdb_show.fanart('en').first.url rescue nil

      show.update_attributes(new_show_data)
      show
    end

  end
end
