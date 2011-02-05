class StatsController < ApplicationController

  def index
    @shows = Show.count
    @episodes = Episode.count
  end

end
