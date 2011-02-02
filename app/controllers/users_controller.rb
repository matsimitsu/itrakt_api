class UsersController < ApplicationController

  def watched
    name = params[:name]
    key = params[:api_key] || 'f05a4d93a7b0838ea46b12a6e86c6cdb'
    password = params[:password] || Digest::SHA1.hexdigest("uT3x5w")
    watched = Rails.cache.fetch("watched_#{name}_#{key}", :expires_in => 10.minutes) do
      Trakt::User::Watched.new(key, name, password).enriched_results.to_json
    end
    render :text => watched
  end

  def calendar
    name = params[:name]
    key = params[:api_key] || 'f05a4d93a7b0838ea46b12a6e86c6cdb'
    password = params[:password] || Digest::SHA1.hexdigest("uT3x5w")
    calendar = Rails.cache.fetch("calendar_#{name}_#{key}", :expires_in => 10.minutes) do
      Trakt::User::Calendar.new(key, name, password).enriched_results.to_json
    end
    render :text => calendar
  end

  def library
    name = params[:name]
    key = params[:api_key] || 'f05a4d93a7b0838ea46b12a6e86c6cdb'
    password = params[:password] || Digest::SHA1.hexdigest("uT3x5w")
    library = Rails.cache.fetch("library_#{name}_#{key}", :expires_in => 10.minutes) do
      Trakt::User::Library.new(key, name, password).enriched_results.to_json
    end
    render :text => library
  end

end
