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

  class Base
    attr_accessor :results, :username, :password, :tvdb_id

    def initialize(username, password)
      self.username = username
      self.password = password
      body = {:username => username, :password => password}.to_json
      self.results = Yajl::HttpStream.post(url, body)
    end
  end

  module User

    class Library < Trakt::Base

      def url
        "#{Trakt::base_url}/user/library/shows.json/#{Trakt::API_KEY}/#{username}"
      end

      def enriched_results
        results.map do |res|
          show = ::Show.find_or_fetch_from_tvdb_id(res['tvdb_id'])
          res['poster'] = Trakt::external_url(show.poster.url)
          res['overview'] = show.overview
          res['network'] = show.network
          res['air_time'] = show.air_time
          res
        end
      end
    end

    class Calendar < Trakt::Base

      def url
        "#{Trakt::base_url}/user/calendar/shows.json/#{Trakt::API_KEY}/#{username}"
      end

      def enriched_results
        results.map do |day|
          day['date_epoch'] = Date.parse(day['date']).strftime('%s')
          day['episodes'].map do |res|
            show = ::Show.find_or_fetch_from_tvdb_id(res['show']['tvdb_id'])
            res['show']['poster'] = Trakt::external_url(show.poster.url)

            res['show']['overview'] = show.overview
            res['show']['network'] = show.network
            res['show']['air_time'] = Time.parse(show.air_time).strftime("%T")
            episode = Episode.find_or_fetch_from_show_and_season_and_episode(show, res['episode']['season'], res['episode']['number'])
            res['episode']['overview'] = episode.overview
            res['episode']['thumb'] = Trakt::external_url(episode.thumb_filename.present? ? episode.thumb.url : show.default_thumb.url)
            res
          end
          day
        end
      end
    end

    class Watched < Trakt::Base

      def url
        "#{Trakt::base_url}/user/watched/episodes.json/#{Trakt::API_KEY}/#{username}"
      end

      def enriched_results
        results.map do |res|
          show = ::Show.find_or_fetch_from_tvdb_id(res['show']['tvdb_id'])
          res['show']['banner'] = Trakt::external_url(show.banner.url)
          res['show']['overview'] = show.overview

          episode = Episode.find_or_fetch_from_show_and_season_and_episode(show, res['episode']['season'], res['episode']['number'])
          res['episode']['overview'] = episode.overview
          res
        end
      end

    end

    class Show < Trakt::Base

      def initialize(tvdb_id)
        self.tvdb_id = tvdb_id
        self.results = Yajl::HttpStream.get(url)
      end

      def url
        "#{Trakt::base_url}/show/summary.json/#{Trakt::API_KEY}/#{tvdb_id}/true"
      end

      def enriched_results
        show = ::Show.find_or_fetch_from_tvdb_id(tvdb_id)
        results['top_episodes'].map do |ep|
          episode = Episode.find_or_fetch_from_show_and_season_and_episode(show, ep['season'], ep['number'])
          ep['overview'] = episode.overview
          ep['thumb'] = Trakt::external_url(episode.thumb_filename.present? ? episode.thumb.url : show.default_thumb.url)
        end
        results['banner'] = Trakt::external_url(show.banner.url)
        results
      end
    end

    class Seasons < Trakt::Base

      def initialize(tvdb_id)
        self.tvdb_id = tvdb_id
        self.results = Yajl::HttpStream.get(url)
      end
      def url
        "#{Trakt::base_url}/show/seasons.json/#{Trakt::API_KEY}/#{tvdb_id}"
      end

      def enriched_results
        results
      end
    end

    class Season < Trakt::Base
      attr_accessor :season

      def initialize(tvdb_id, season)
        self.tvdb_id = tvdb_id
        self.season = season
        self.results = Yajl::HttpStream.get(url)
      end
      def url
        "#{Trakt::base_url}/show/season.json/#{Trakt::API_KEY}/#{tvdb_id}/#{season}"
        Rails.logger.debug("#{Trakt::base_url}/show/season.json/#{Trakt::API_KEY}/#{tvdb_id}/#{season}")
      end

      def enriched_results
        show = ::Show.find_or_fetch_from_tvdb_id(tvdb_id)
        results.map do |ep|
          episode = Episode.find_or_fetch_from_show_and_season_and_episode(show, season, ep['episode'])
          ep['overview'] = episode.overview
          ep['thumb'] = Trakt::external_url(episode.thumb_filename.present? ? episode.thumb.url : show.default_thumb.url)
        end
        results
      end
    end

  end

end



