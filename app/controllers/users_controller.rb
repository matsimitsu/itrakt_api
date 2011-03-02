class UsersController < ApplicationController

  before_filter :set_username_and_password

  def watched
    render :text => Trakt::User::Watched.new(@username, @password).enriched_results.to_json
  end

  def calendar
    render :text => Trakt::User::Watched.new(@username, @password).enriched_results.to_json
  end

  def library
    render :text => Trakt::User::Library.new(@username, @password).enriched_results.to_json
  end

end
