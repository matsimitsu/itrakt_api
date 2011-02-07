class ShowsController < ApplicationController

  def show
    tvdb_id = params[:id]
    library = Rails.cache.fetch("show_#{tvdb_id}", :expires_in => 10.minutes) do
      Trakt::Show::Show.new(tvdb_id).enriched_results.to_json
    end
    render :text => library
  end

  def seasons
    tvdb_id = params[:tvdb_id]
    result = Rails.cache.fetch("seasons_#{tvdb_id}", :expires_in => 10.minutes) do
      Trakt::Show::Seasons.new(tvdb_id).enriched_results.to_json
    end
    render :text => result
  end

  def season
    tvdb_id = params[:tvdb_id]
    season_number = params[:season_number]
    result = Rails.cache.fetch("season_#{tvdb_id}_#{season_number}", :expires_in => 10.minutes) do
      Trakt::Show::Season.new(tvdb_id, season_number).enriched_results.to_json
    end
    render :text => result
  end

  def seasons_with_episodes
    tvdb_id = params[:tvdb_id]
    result = Rails.cache.fetch("season_with_episodes_#{tvdb_id}", :expires_in => 1.day) do
      Trakt::Show::SeasonsWithEpisodes.new(tvdb_id).enriched_results.to_json
    end
    render :text => result
  end

  def trending
    tvdb_id = params[:tvdb_id]
    season_number = params[:season_number]
    result = Rails.cache.fetch("trending", :expires_in => 5.minutes) do
      Trakt::Show::Trending.new.enriched_results.to_json
    end
    render :text => result
  end
end
