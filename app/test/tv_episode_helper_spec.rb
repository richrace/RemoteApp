require 'helpers/tv_episode_helper'

describe "TvEpisodeHelper" do

  class TempClass 
  end

  before(:all) do
    Rhom::Rhom.database_full_reset
    @test_class = TempClass.new
    @test_class.extend(TvEpisodeHelper)

    @xbmc = XbmcConfig.create(
      :name => "Test", 
      :url => "localhost",
      :port => 8080, 
      :usrname => "xbmc", 
      :password => "xbmc", 
      :active => "true", 
      :version => "4")

    @tvshow = Tvshow.create(
      :xbmc_id => @xbmc.object,
      :xlib_id => 1,
      :title => "An Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009)

    @season = Tvseason.create(
      :xbmc_id => @xbmc.object,
      :xlib_id => 1,
      :tvshow_id => 1, 
      :label => "test",
      :showtitle => "Test",
      :thumb => "Test",
      :fanart => "test")
  end

  before(:each) do
    (1..5).each do |num|
      Tvepisode.create(
        :xbmc_id => @xbmc.object,
        :xlib_id => num,
        :episode => num,
        :firstaired => "2/3/2001",
        :tvshow_id => 1,
        :tvshow_name => "Test",
        :tvseason_id => 1,
        :runtime => "test",
        :title => "Test",
        :label => "test",
        :thumb => "test",
        :fanart => "test",
        :plot => "test",
        :rating => 9.9)
    end
  end

  after(:each) do
    Tvepisode.find(:all).each { |x| x.destroy }
  end

  after(:all) do
    @xbmc.destroy
  end

  it "should filter all tv episodes by current xbmc config, season id, tv show id " do
    man_episodes = Tvepisode.find(:all, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :tvshow_id => 1, :tvseason_id => 1}, :order => :episode, :orderdir => 'ASC')

    fil_epsiodes = @test_class.find_episodes(1, 1)

    fil_epsiodes.length.should == man_episodes.length
    (fil_epsiodes[0].to_s == man_episodes[0].to_s).should == true
    (fil_epsiodes[1].to_s == man_episodes[1].to_s).should == true
    (fil_epsiodes[2].to_s == man_episodes[2].to_s).should == true
    (fil_epsiodes[3].to_s == man_episodes[3].to_s).should == true
    (fil_epsiodes[4].to_s == man_episodes[4].to_s).should == true
  end

  it "should find episode " do
    found = Tvepisode.find(:first, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :xlib_id => 1})

    help_found = @test_class.find_episode(1)

    found.xlib_id.should == help_found.xlib_id
  end

  it "should add new tv episode" do
    # Make sure it's not in the database.
    found = Tvepisode.find(:all, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :xlib_id => 100})
    found.length.should == 0

    new_episode = {
      :episodeid => 100,
      :episode => 100,
      :firstaired => "2/3/2001",
      :title => "Test",
      :tvshowid => 1,
      :season => 1,
      :runtime => 0,
      :rating => 8,
      :plot => "Test",
      :thumbnail => "Test",
      :fanart => "Test"
    }

    # Needs to be in an array
    n_episodes = [new_episode]
    
    @test_class.handle_new_tvepisodes(n_episodes).should == true

    # Usings :all to make sure that only one result is found.
    found = Tvepisode.find(:all, :conditions => {:xlib_id => 100})
    found.length.should == 1
    found[0].xlib_id.should == 100
  end

  it "should not add new tv episode with same ID" do
    # Make sure that the tv episode is already in the DB.
    found = Tvepisode.find(:all, :conditions => {:xlib_id => 5})
    found.length.should == 1
    found[0].xlib_id.should == 5

    # Create new tv episode with tv episode ID 5 in XBMC Format (hash)
    new_episode = {
      :episodeid => 5,
      :episode => 5,
      :firstaired => "2/3/2001",
      :title => "Test",
      :tvshowid => 1,
      :season => 1,
      :runtime => 0,
      :rating => 8,
      :plot => "Test",
      :thumbnail => "Test",
      :fanart => "Test"
    }
    # Needs to be in an array
    n_episodes = [new_episode]
    
    @test_class.handle_new_tvepisodes(n_episodes).should == false

    # Usings :all to make sure that only one result is found.
    found = Tvepisode.find(:all, :conditions => {:xlib_id => 5})
    found.length.should == 1
    found[0].xlib_id.should == 5
  end

  it "should only get tv episodes with active XBMC" do 
    # Create non active XBMC
    temp_xbmc = XbmcConfig.create(
      :name => "Test2", 
      :url => "localhost",
      :port => 8080, 
      :usrname => "xbmc", 
      :password => "xbmc", 
      # Note active is false
      :active => "false", 
      :version => "4")
    # Create some temp tv episodes.
    (1..3).each do | num |
      Tvepisode.create(
        :xbmc_id => temp_xbmc.object,
        :xlib_id => num + 10,
        :episode => num + 10,
        :firstaired => "2/3/2001",
        :tvshow_id => 1,
        :tvshow_name => "Test",
        :tvseason_id => 1,
        :runtime => "test",
        :title => "Test",
        :label => "test",
        :thumb => "test",
        :fanart => "test",
        :plot => "test",
        :rating => 9.9)
    end

    all_episodes = Tvepisode.find(:all)
    found = @test_class.find_episodes(1,1)

    all_episodes.length.should == 8
    found.length.should == 5
    found.each do |f_episode|
      f_episode.xbmc_id.to_f.should == @xbmc.object.to_f
    end
  end

  it "should remove tv episode from DB which isn't in XBMC" do
    # Create new tv episode with tv episode ID 150 in XBMC Format (hash)
    new_episode = {
      :episodeid => 150,
      :episode => 150,
      :firstaired => "2/3/2001",
      :title => "Test",
      :tvshowid => 1,
      :season => 1,
      :runtime => 0,
      :rating => 8,
      :plot => "Test",
      :thumbnail => "Test",
      :fanart => "Test"
    }
    # Needs to be in an array
    n_episodes = [new_episode]
    # Add it to the database
    @test_class.handle_new_tvepisodes(n_episodes)

    # Remove ALL other tv episodes apart from the new "list"
    @test_class.handle_removed_tvepisodes(n_episodes, 1, 1).should == true

    found = Tvepisode.find(:all)
    found.length.should == 1
    found[0].xlib_id.should == 150
  end

  it "should not remove tv episode from DB which isn't in XBMC" do
    # Delete all tv episodes
    Tvepisode.find(:all).each {|x| x.destroy}

    # Create new tv episode with tv episode ID 151 in XBMC Format (hash)
    new_episode = {
      :episodeid => 151,
      :episode => 151,
      :firstaired => "2/3/2001",
      :title => "Test",
      :tvshowid => 1,
      :season => 1,
      :runtime => 0,
      :rating => 8,
      :plot => "Test",
      :thumbnail => "Test",
      :fanart => "Test"
    }
    # Needs to be in an array
    n_episodes = [new_episode]
    # Add it to the database
    @test_class.handle_new_tvepisodes(n_episodes)

    # Should only be one tv episode
    found = Tvepisode.find(:all)
    found.length.should == 1

    # Should not remove any tv episode.
    @test_class.handle_removed_tvepisodes(n_episodes,1,1).should == false

    # There still should only be one tv episode.
    found = Tvepisode.find(:all)
    found.length.should == 1
    found[0].xlib_id.should == 151
  end

end