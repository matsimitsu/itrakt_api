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
    :rating => 'rating',
    :tvdb_id => 'id'
  }

  field :overview
  field :genres, :type => Hash, :default => {}
  field :runtime
  field :name
  field :first_aired, :type => Date
  field :network
  field :rating
  field :tvdb_id
  field :remote_banner_url
  field :remote_poster_url
  index :tvdb_id


  references_many :episodes

  mount_uploader :banner, BannerUploader
  mount_uploader :poster, PosterUploader

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

      create(new_show_data)
    end

  end
end
