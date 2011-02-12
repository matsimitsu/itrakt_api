class UpdatesController < ApplicationController

  def index
    @updates = TvdbUpdate.desc(:created_at).limit(50)
  end

  def show
    @update = TvdbUpdate.find(params[:id])
  end

end
