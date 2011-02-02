class ShowsController < ApplicationController

  def show
    @show = Show.first(:conditions => { :tvdb_id => params[:id]})
    if @show
      render :text => @show.to_json
    else
      render :nothing => true, :head => :not_found
    end
  end

  def season
    @show = Show.first(:conditions => { :tvdb_id => params[:tvdb_id]})
    if @show
      render :text => @show.embedded_episodes_by_season(params[:season_number]).to_json
    else
      render :nothing => true, :head => :not_found
    end
  end

end
