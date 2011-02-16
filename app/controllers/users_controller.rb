class UsersController < ApplicationController

  before_filter :set_username_and_password

  def watched
    password = @password || DEFAULT_PASSWORD
    watched = Rails.cache.fetch("watched_#{@username}", :expires_in => 10.minutes) do
      Trakt::User::Watched.new(@username, password).enriched_results.to_json
    end
    render :text => watched
  end

  def calendar
    password = @password || DEFAULT_PASSWORD
    calendar = Rails.cache.fetch("calendar_#{@username}", :expires_in => 10.minutes) do
      Trakt::User::Calendar.new(@username, password).enriched_results.to_json
    end
    render :text => calendar
  end

  def library
    password = @password || DEFAULT_PASSWORD
    library = Rails.cache.fetch("library_#{@username}", :expires_in => 10.minutes) do
      Trakt::User::Library.new(@username, password).enriched_results.to_json
    end
    render :text => library
  end

  def set_username_and_password
    # TODO: Remove this when app uses http auth
    if params[:name]
      @username = params[:name]
      return
    end
    if params[:username] && params[:password]
      @username, @password = params[:username], params[:password]
    else
       authenticate_with_http_basic do |user_name, password|
        @username, @password = user_name, password
      end
    end

    render :status => :unauthorized, :text => nil unless @username && @password
  end

end
