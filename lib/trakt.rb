require 'uri'
require 'yajl/http_stream'

module Trakt

  def self.base_url
    "http://api.trakt.tv"
  end

  def self.external_url(url)
    return unless url
    "#{root_url}#{url}"
  end

  module User

    class Calendar

      attr_accessor :url, :results

      def path
        "user/calendar/shows.json/"
      end

      def initialize(api_key, username)
        self.url = "#{Trakt::base_url}/#{path}/#{api_key}/#{username}/#{1.day.ago.strftime("%Y%m%d")}"
        self.results = Yajl::HttpStream.get(url)
      end

      def enriched_results
        results.map do |day|
          day['episodes'].map do |res|
            show = Show.find_or_fetch_from_tvdb_id(res['show']['tvdb_id'])
            res['show']['banner'] = Trakt::external_url(show.banner.url)
            res['show']['poster'] = Trakt::external_url(show.poster.url)
            res['show']['overview'] = show.overview
            res['show']['network'] = show.network

            episode = Episode.find_or_fetch_from_show_and_season_and_episode(show, res['episode']['season'], res['episode']['number'])
            res['episode']['overview'] = episode.overview
            res['episode']['thumb'] = Trakt::external_url(episode.thumb.url)
            res
          end
          day
        end
      end
    end

    class Watched

      attr_accessor :url, :results

      def path
        "user/watched/episodes.json/"
      end

      def initialize(api_key, username)
        self.url = "#{Trakt::base_url}/#{path}/#{api_key}/#{username}"
        self.results = Yajl::HttpStream.get(url)
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



