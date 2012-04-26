require 'helpers/tv_season_helper'

describe "TvSeasonHelper" do

  class TempClass 
  end

  before(:all) do
    Rhom::Rhom.database_full_reset
    @test_class = TempClass.new
    @test_class.extend(TvSeasonHelper)

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
  end

  before(:each) do
    (1..5).each do |num|
      Tvseason.create(
        :xbmc_id => @xbmc.object,
        :xlib_id => num,
        :tvshow_id => 1, 
        :label => "test",
        :showtitle => "Test",
        :thumb => "Test",
        :fanart => "test")
    end
  end

  after(:each) do
    Tvseason.find(:all).each { |x| x.destroy }
  end

  after(:all) do
    @xbmc.destroy
    @tvshow
  end

  it "should filter all tv seasons by current xbmc config, tv show id " do
    man_seasons = Tvseason.find(:all, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :tvshow_id => 1})

    fil_seasons = @test_class.find_seasons(1)

    fil_seasons.length.should == man_seasons.length
    (fil_seasons[0].to_s == man_seasons[0].to_s).should == true
    (fil_seasons[1].to_s == man_seasons[1].to_s).should == true
    (fil_seasons[2].to_s == man_seasons[2].to_s).should == true
    (fil_seasons[3].to_s == man_seasons[3].to_s).should == true
    (fil_seasons[4].to_s == man_seasons[4].to_s).should == true
  end

  it "should find season" do
    found = Tvseason.find(:first, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :tvshow_id => 1, :xlib_id => 1})

    help_found = @test_class.find_season(1,1)

    found.xlib_id.should == help_found.xlib_id
  end

  it "should add new tv season" do
    # Make sure it's not in the database.
    found = Tvseason.find(:all, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :xlib_id => 100})
    found.length.should == 0

    new_season = {
      :season => 100,
      :tvshowid => 1,
      :label => "Test",
      :showtitle => "Test",
      :thumbnail => "test",
      :fanart => "test"
    }

    # Needs to be in an array
    n_seasons = [new_season]
    
    @test_class.handle_new_seasons(n_seasons).should == true

    # Usings :all to make sure that only one result is found.
    found = Tvseason.find(:all, :conditions => {:xlib_id => 100})
    found.length.should == 1
    found[0].xlib_id.should == 100
  end

  it "should not add new tv season with same ID" do
    # Make sure that the tv season is already in the DB.
    found = Tvseason.find(:all, :conditions => {:xlib_id => 5})
    found.length.should == 1
    found[0].xlib_id.should == 5

    # Create new tv season with tv season ID 5 in XBMC Format (hash)
    new_season = {
      :season => 5,
      :tvshowid => 1,
      :label => "Test",
      :showtitle => "Test",
      :thumbnail => "test",
      :fanart => "test"
    }
    # Needs to be in an array
    n_seasons = [new_season]
    
    @test_class.handle_new_seasons(n_seasons).should == false

    # Usings :all to make sure that only one result is found.
    found = Tvseason.find(:all, :conditions => {:xlib_id => 5})
    found.length.should == 1
    found[0].xlib_id.should == 5
  end

  it "should only get tv seasons with active XBMC" do 
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
      Tvseason.create(
        :xbmc_id => temp_xbmc.object,
        :xlib_id => num + 10,
        :tvshow_id => 1, 
        :label => "test",
        :showtitle => "Test",
        :thumb => "Test",
        :fanart => "test")
    end

    all_seasons = Tvseason.find(:all)
    found = @test_class.find_seasons(1)

    all_seasons.length.should == 8
    found.length.should == 5
    found.each do |f_seasons|
      f_seasons.xbmc_id.to_f.should == @xbmc.object.to_f
    end
  end

  it "should remove tv seasons from DB which isn't in XBMC" do
    # Create new tv season with tv season ID 150 in XBMC Format (hash)
    new_season = {
      :season => 150,
      :tvshowid => 1,
      :label => "Test",
      :showtitle => "Test",
      :thumbnail => "test",
      :fanart => "test"
    }
    # Needs to be in an array
    n_seasons = [new_season]
    # Add it to the database
    @test_class.handle_new_seasons(n_seasons)

    # Remove ALL other tv episodes apart from the new "list"
    @test_class.handle_removed_seasons(n_seasons, 1).should == true

    found = Tvseason.find(:all)
    found.length.should == 1
    found[0].xlib_id.should == 150
  end

  it "should not remove tv season from DB which isn't in XBMC" do
    # Delete all tv seasons
    Tvseason.find(:all).each {|x| x.destroy}

    # Create new tv season with tv season ID 151 in XBMC Format (hash)
    new_season = {
      :season => 151,
      :tvshowid => 1,
      :label => "Test",
      :showtitle => "Test",
      :thumbnail => "test",
      :fanart => "test"
    }
    # Needs to be in an array
    n_seasons = [new_season]
    # Add it to the database
    @test_class.handle_new_seasons(n_seasons)

    # Should only be one tv episode
    found = Tvseason.find(:all)
    found.length.should == 1

    # Should not remove any tv episode.
    @test_class.handle_removed_seasons(n_seasons,1).should == false

    # There still should only be one tv episode.
    found = Tvseason.find(:all)
    found.length.should == 1
    found[0].xlib_id.should == 151
  end

end