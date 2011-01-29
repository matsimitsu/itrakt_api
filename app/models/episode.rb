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
    :tvdb_id => 'id'
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

  class << self

    def find_or_fetch_from_show_and_season_and_episode(show, season, episode)
      first(:conditions => { :show_id => show.id, :season_number => season, :episode_number => episode }) || create_from_show_and_season_and_episode(show, season, episode)
    end

    def create_from_show_and_season_and_episode(show, season, episode)
      Rails.logger.info("Requesting episode from TVDB: #{show.name} [#{season}x#{episode}]")

      tvdb = show.tvdb_reference
      episode = tvdb.get_episode(season, episode)

      new_episode_data = {}
      API_FIELDS.each do |fld, remote_fld|
        new_episode_data[fld] = episode.send(remote_fld)
      end

      new_episode_data[:remote_thumb_url] = episode.thumb rescue nil

      show.episodes.create(new_episode_data)
    end
  end

end