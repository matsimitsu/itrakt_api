require 'uri'
require 'yajl/http_stream'
require 'digest/sha1'

module Trakt

  def self.base_url
    "http://api.trakt.tv"
  end

  def self.external_url(url)
    return unless url
    "#{root_url}#{url}"
  end

  module User

    class Library

      attr_accessor :url, :results

      def path
        "user/library/shows.json"
      end

      def initialize(api_key, username, password)
        self.url = "#{Trakt::base_url}/#{path}/#{api_key}/#{username}"
        body = {:username => username, :password => password}.to_json
        self.results = Yajl::HttpStream.post(url, body)
      end

      def enriched_results
        results.map do |res|
          show = Show.find_or_fetch_from_tvdb_id(res['tvdb_id'])
          res['poster'] = Trakt::external_url(show.poster.url)
          res['overview'] = show.overview
          res['network'] = show.network
          res['air_time'] = show.air_time
          res
        end
      end
    end

    class Calendar

      attr_accessor :url, :results

      def path
        "user/calendar/shows.json"
      end

      def initialize(api_key, username, password)
        self.url = "#{Trakt::base_url}/#{path}/#{api_key}/#{username}/#{1.day.ago.strftime("%Y%m%d")}"
        body = {:username => username, :password => password}.to_json
        self.results = Yajl::HttpStream.post(url, body)
      end

      def enriched_results
        results.map do |day|
          day['date_epoch'] = Date.parse(day['date']).strftime('%s')
          day['episodes'].map do |res|
            show = Show.find_or_fetch_from_tvdb_id(res['show']['tvdb_id'])
            res['show']['poster'] = Trakt::external_url(show.poster.url)

            res['show']['overview'] = show.overview
            res['show']['network'] = show.network
            res['show']['air_time'] = show.air_time
            episode = Episode.find_or_fetch_from_show_and_season_and_episode(show, res['episode']['season'], res['episode']['number'])
            res['episode']['overview'] = episode.overview
            res['episode']['thumb'] = Trakt::external_url(episode.thumb_filename.present? ? episode.thumb.url : show.default_thumb.url)
            res
          end
          day
        end
      end
    end

    class Watched

      attr_accessor :url, :results

      def path
        "user/watched/episodes.json"
      end

      def initialize(api_key, username, password)
        self.url = "#{Trakt::base_url}/#{path}/#{api_key}/#{username}"
        body = {:username => username, :password => password}.to_json
        self.results = Yajl::HttpStream.post(url, body)
      end

      def enriched_results
        results.map do |res|
          show = Show.find_or_fetch_from_tvdb_id(res['show']['tvdb_id'])
          res['show']['banner'] = Trakt::external_url(show.banner.url)
          res['show']['overview'] = show.overview

          episode = Episode.find_or_fetch_from_show_and_season_and_episode(show, res['episode']['season'], res['episode']['number'])
          res['episode']['overview'] = episode.overview
          res
        end
      end


    end

  end

end



