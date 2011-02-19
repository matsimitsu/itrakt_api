class UsersController < ApplicationController

  before_filter :set_username_and_password

  def watched
    password =
    watched = Rails.cache.fetch("watched_#{@username}", :expires_in => 10.minutes) do
      Trakt::User::Watched.new(@username, @password).enriched_results.to_json
    end
    render :text => watched
  end

  def calendar
    password = @password || DEFAULT_PASSWORD
    calendar = Rails.cache.fetch("calendar_#{@username}", :expires_in => 10.minutes) do
      Trakt::User::Calendar.new(@username, @password).enriched_results.to_json
    end
    render :text => calendar
  end

  def library
    password = @password || DEFAULT_PASSWORD
    library = Rails.cache.fetch("library_#{@username}", :expires_in => 10.minutes) do
      Trakt::User::Library.new(@username, @password).enriched_results.to_json
    end
    render :text => library
  end


end
