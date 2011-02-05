require 'spec_helper'

describe Show do

  it "should have a valid blueprint" do
    show = Show.make
    show.should be_valid
  end

  context "find_or_fetch_from_tvdb_id" do
    before do
      @show = Show.make(:tvdb_id => '12345')
    end

    it "should find existing show by tvdb_id" do
      Show.should_not_receive(:create_from_tvdb_id)
      Show.find_or_fetch_from_tvdb_id('12345').should == @show
    end

    it "should create new show if tvdb_id doesn't exist" do
      Show.should_receive(:create_from_tvdb_id)
      Show.find_or_fetch_from_tvdb_id('123456')
    end
  end

  context "create_from_tvdb_id" do
    before do
      @tvdb_request = TvdbParty::Search.new(TVDB_API_KEY)
      TvdbParty::Search.should_receive(:new).and_return(@tvdb_request)
    end

    it "should create a show for tvdb_id" do
      show = Show.create_from_tvdb_id('82438')
      show.name.should == 'Flashpoint'
      show.overview.should == 'Flashpoint is an emotional journey following the lives of members of the Strategic Response Unit as they solve hostage situations, bust gangs, and defuse bombs. They work by utilizing their training to get inside the heads of these people in order to make them reach their breaking point (aka their flashpoint).'
    end
  end

  context "thumbs" do

    it "should return the default tumb url" do
      show = Show.new
      show.thumb_url.should == '/images/default_thumb.jpg'
    end

    it "should return the default poster url" do
      show = Show.new
      show.poster_url.should == '/images/default_poster.jpg'
    end
  end
end