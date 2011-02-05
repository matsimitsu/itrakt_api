class UsersController < ApplicationController

  def watched
    name = params[:name]
    password = params[:password] || DEFAULT_PASSWORD
    watched = Rails.cache.fetch("watched_#{name}", :expires_in => 10.minutes) do
      Trakt::User::Watched.new(name, password).enriched_results.to_json
    end
    render :text => watched
  end

  def calendar
    name = params[:name]
    password = params[:password] || DEFAULT_PASSWORD
    calendar = Rails.cache.fetch("calendar_#{name}", :expires_in => 10.minutes) do
      Trakt::User::Calendar.new(name, password).enriched_results.to_json
    end
    render :text => calendar
  end

  def library
    name = params[:name]
    password = params[:password] || DEFAULT_PASSWORD
    library = Rails.cache.fetch("library_#{name}", :expires_in => 10.minutes) do
      Trakt::User::Library.new(name, password).enriched_results.to_json
    end
    render :text => library
  end

end
