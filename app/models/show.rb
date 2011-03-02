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
  field :update_episodes, :type => Boolean, :default => false

  references_many :episodes, :dependent => :delete

  mount_uploader :banner, BannerUploader
  mount_uploader :poster, PosterUploader
  mount_uploader :default_thumb, DefaultThumbUploader

  index :tvdb_id

  validates_presence_of :name, :on => :update

  def updateable?
    updated_at == nil || updated_at < 1.day.ago || name.blank?
  end

  def poster_url
    poster_filename.present? ? poster.url(:retina) : nil
  end

  def thumb_url
    default_thumb_filename.present? ? default_thumb.url : '/images/default_thumb.jpg'
  end

  def tvdb_reference
    tvdb = TvdbParty::Search.new(Tvdb::API_KEY)
    tvdb.get_series_by_id(tvdb_id)
  end

  def update_data_from_tvdb_results(tvdb_show)
    new_show_data = {}

    API_FIELDS.each do |fld, remote_fld|
      new_show_data[fld] = tvdb_show.send(remote_fld)
    end

    new_show_data[:remote_banner_url] = tvdb_show.series_banners('en').first.url rescue nil
    new_show_data[:remote_poster_url] = tvdb_show.posters('en').first.url rescue nil
    new_show_data[:remote_default_thumb_url] = tvdb_show.fanart('en').first.url rescue nil
    update_attributes(new_show_data)
    self
  end

  def update_episodes
    results = Trakt::Show::SeasonsWithEpisodes.new(tvdb_id).results
    episodes = results.map { |r| r['episodes'] }
    episodes.each do |episode|
      Episode.find_or_fetch_from_show_and_season_and_episode(self, episode['season'], episode['episode'])
      sleep 2
    end
    update_attributes(:update_episodes, false)
  end

  class << self

    def find_or_fetch_from_tvdb_id(tvdb_id)
      first(:conditions => { :tvdb_id => tvdb_id }) || update_or_create_from_tvdb_id(tvdb_id, { :update_episodes => true })
    end

    def update_or_create_from_tvdb_id(tvdb_id, default_attributes={})
      Rails.logger.info("Requesting show from TVDB: #{tvdb_id}")

      tvdb = TvdbParty::Search.new(Tvdb::API_KEY)
      tvdb_show = tvdb.get_series_by_id(tvdb_id)

      show = Show.find_or_create_by(:tvdb_id => tvdb_id)
      show.update_attributes(default_attributes)
      show.update_data_from_tvdb_results(tvdb_show)
    end

    def fetch_episodes
      Show.where(:update_episodes => true).each do |show|
        show.update_episodes
      end
    end

    def update_outdated
      tvdb_ids = Show.where(:updated_at.lt => 1.week.ago.utc).map(&:tvdb_id)
      TvdbUpdate.create(:series => tvdb_ids, :update_type => 'show').run if tvdb_ids.any?
    end
  end
end
