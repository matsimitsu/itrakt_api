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
  embeds_many :embedded_episodes, :class_name => 'Show::EmbeddedEpisode'

  mount_uploader :banner, BannerUploader
  mount_uploader :poster, PosterUploader
  mount_uploader :default_thumb, DefaultThumbUploader


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

  def update_episodes
    fetched_episodes = tvdb_reference.episodes
    fetched_episodes.each do |episode|
      new_episode = create_embedded_episode_from_tvdb_data(episode)
      unless embedded_episodes.map(&:identifier).include?(new_episode.identifier)
        embedded_episodes << new_episode
        Rails.logger.info("Added: #{new_episode.name} TO #{name}")
      end
    end
    save
  end

  def embedded_episodes_by_season(season_number)
    embedded_episodes.select { |ee| ee.season_number.to_s == season_number.to_s } rescue []
  end

  def embedded_episode(season_number, episode_number)
    embedded_episodes.select { |ee| ee.season_number == season_number && ee.episode_number == episode_number }.first rescue nil
  end

  def create_embedded_episode_from_tvdb_data(episode)
    new_episode_data = {}
    new_episode_data[:identifier] = "#{episode.season_number}x#{episode.number}"

    EmbeddedEpisode::API_FIELDS.each do |fld, remote_fld|
      new_episode_data[fld] = episode.send(remote_fld)
    end

    Show::EmbeddedEpisode.new(new_episode_data)
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

  end
end
