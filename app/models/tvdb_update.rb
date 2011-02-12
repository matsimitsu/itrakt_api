class TvdbUpdate
  include Mongoid::Document
  include Mongoid::Timestamps

  API_FIELDS = {
    :timestamp => 'Time',
    :series => 'Series',
    :episodes => 'Episode'
  }


  field :timestamp, :type => Integer
  field :episodes, :type => Array, :default => []
  field :series, :type => Array, :default => []
  field :results, :type => Hash, :default => {}


  def run
    series.each do |serie_id|
      begin
        show = Show.update_or_create_from_tvdb_id(serie_id)
        results[serie_id] = { :type => 'show', :status => 'ok', :show_id => show.id }
      rescue => e
        results[serie_id] = { :type => 'show', :status => 'failed', :message => e.message }
      end
    end

    episodes.each do |episode_id|
      begin
        episode = Episode.update_or_create_from_tvdb_id(episode_id)
        results[serie_id] = { :type => 'episode', :status => 'ok', :episode_id => episode.id }
      rescue => e
        results[serie_id] = { :type => 'episode', :status => 'failed', :message => e.message }
      end
    end
  end


  def self.fetch
    last_update = TvdbUpdate.last ? TvdbUpdate.last.timestamp : 1.day.ago.to_i
    tvdb = TvdbParty::Search.new(Tvdb::API_KEY)
    tvdb_results = tvdb.get_all_updates(last_update)

    new_update_data = {}

    API_FIELDS.each do |fld, remote_fld|
      new_update_data[fld] = tvdb_results[remote_fld]
    end

    create(new_update_data)
  end

  def self.fetch_and_run
    tvdb_update = self.fetch
    tvdb_update.run
  end
end
