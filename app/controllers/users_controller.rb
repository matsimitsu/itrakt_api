class UsersController < ApplicationController

  def watched
    name = params[:name]
    key = params[:api_key] || 'f05a4d93a7b0838ea46b12a6e86c6cdb'
    watched = Rails.cache.fetch("watched_#{name}_#{key}", :expires_in => 10.minutes) do
      Trakt::User::Watched.new(key, name).enriched_results.to_json
    end
    render :text => watched
  end

  def calendar
    name = params[:name]
    key = params[:api_key] || 'f05a4d93a7b0838ea46b12a6e86c6cdb'
    calendar = Rails.cache.fetch("calendar_#{name}_#{key}", :expires_in => 10.minutes) do
      Trakt::User::Calendar.new(key, name).enriched_results.to_json
    end
    render :text => calendar
  end


end
