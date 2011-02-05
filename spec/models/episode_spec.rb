require 'spec_helper'

describe Episode do

  before :all do
    @show = tvdb_show
    @another_show = another_tvdb_show
  end
  it "should have a valid blueprint" do
    episode = Episode.make
    episode.should be_valid
  end

  context "find_or_fetch_from_show_and_season_and_episode" do
    before :all do
      @episode = Episode.create!(:show_id => @show.id, :season_number => 1, :episode_number => 1)
    end

    it "should find existing episode by show, season and episode" do
      Episode.should_not_receive(:create_from_show_and_season_and_episode)
      Episode.find_or_fetch_from_show_and_season_and_episode(@show, 1, 1).should == @episode
    end

    it "should create new show if show doesn't exist" do
      Episode.should_receive(:create_from_show_and_season_and_episode)
      Episode.find_or_fetch_from_show_and_season_and_episode(@another_show, 1, 1)
    end

    it "should create new show if season doesn't exist" do
      Episode.should_receive(:create_from_show_and_season_and_episode)
      Episode.find_or_fetch_from_show_and_season_and_episode(@show, 2, 1)
    end

    it "should create new show if episode doesn't exist" do
      Episode.should_receive(:create_from_show_and_season_and_episode)
      Episode.find_or_fetch_from_show_and_season_and_episode(@show, 1, 2)
    end
  end


  context "thumbs" do

    it "should return the default show tumb url" do
      episode = @show.episodes.new
      episode.thumb_url.should == '/uploads/82438/default_thumb-82438.jpg'
    end

    it "should return the default tumb url" do
      @show.thumb_filename = nil
      episode = @show.episodes.new
      episode.thumb_url.should == '/images/default_thumb.jpg'
    end

  end
end
