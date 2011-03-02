class UsersController < ApplicationController

  before_filter :set_username_and_password

  def watched
    Trakt::User::Watched.new(@username, @password).enriched_results.to_json
    render :text => watched
  end

  def calendar
    Trakt::User::Calendar.new(@username, @password).enriched_results.to_json
    render :text => calendar
  end

  def library
    Trakt::User::Library.new(@username, @password).enriched_results.to_json
    render :text => library
  end


end
