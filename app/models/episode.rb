class Episode
  include Mongoid::Document
  include Mongoid::Timestamps

  API_FIELDS = {
    :overview => 'overview',
    :season_number => 'season_number',
    :episode_number => 'number',
    :writer => 'writer',
    :director => 'director',
    :name => 'name',
    :air_date => 'air_date',
    :guest_stars => 'guest_stars',
    :tvdb_id => 'id',
    :show_tvdb_id => 'series_id'
  }

  field :season_number, :type => Integer
  field :episode_number, :type => Integer
  field :name
  field :overview
  field :writer
  field :director
  field :air_date, :type => Date
  field :guest_stars, :type => Array
  field :tvdb_id
  field :show_tvdb_id
  field :remote_thumb_url

  index(
    [
      [ :show_id, Mongo::ASCENDING ],
      [ :season_number, Mongo::ASCENDING ],
      [ :episode_number, Mongo::ASCENDING ]
    ]
  )

  referenced_in :show

  mount_uploader :thumb, EpisodeThumbUploader

  validates_presence_of :name, :on => :update

  def thumb_url
    thumb_filename.present? ? thumb.url : show.thumb_url
  end

  def updateable?
    updated_at == nil || updated_at < 6.hours.ago
  end

  def update_data_from_tvdb_results(tvdb_episode)
    new_episode_data = {}
    API_FIELDS.each do |fld, remote_fld|
      new_episode_data[fld] = tvdb_episode.send(remote_fld)
    end

    new_episode_data[:remote_thumb_url] = tvdb_episode.thumb rescue nil

    update_attributes(new_episode_data)
    self
  end

  class << self

    def find_or_fetch_from_show_and_season_and_episode(show, season, episode)
      first(:conditions => { :show_id => show.id, :season_number => season, :episode_number => episode }) || create_from_show_and_season_and_episode(show, season, episode)
    end

    def create_from_show_and_season_and_episode(show, season_number, episode_number)
      Rails.logger.info("Requesting episode from TVDB: #{show.name} [#{season_number}x#{episode_number}]")

      tvdb = show.tvdb_reference
      tvdb_episode = tvdb.get_episode(season_number, episode_number)

      episode = show.episodes.find_or_create_by(:tvdb_id => tvdb_episode.id)
      episode.update_data_from_tvdb_results(tvdb_episode)
    end

    def update_or_create_from_tvdb_id(tvdb_id)
      Rails.logger.info("Requesting episode from TVDB: #{tvdb_id}")

      tvdb = TvdbParty::Search.new(Tvdb::API_KEY)
      tvdb_episode = tvdb.get_episode_by_id(tvdb_id)

      show = Show.find_or_fetch_from_tvdb_id(tvdb_episode.series_id)
      episode = show.episodes.find_or_create_by(:tvdb_id => tvdb_id)

      episode.update_data_from_tvdb_results(tvdb_episode)
    end
  end

end