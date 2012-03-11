require 'helpers/tv_show_helper'

describe "TvShowHelper" do

  class TempClass 
  end

  before(:all) do
    Rhom::Rhom.database_full_reset
    @test_class = TempClass.new
    @test_class.extend(TvShowHelper)

    @xbmc = XbmcConfig.create(
      :name => "Test", 
      :url => "localhost",
      :port => 8080, 
      :usrname => "xbmc", 
      :password => "xbmc", 
      :active => "true", 
      :version => "4")
  end

  before(:each) do
    (1..5).each do |num|
      tmp = Tvshow.create(
        :xbmc_id => @xbmc.object,
        :xlib_id => num,
        :title => "An Test",
        :label => "test",
        :thumb => "test",
        :fanart => "test",
        :plot => "test",
        :tvdb => "test",
        :rating => 9.9,
        :year => 2009)
      tmp.create_sort_title
    end
  end

  after(:each) do
    Tvshow.find(:all).each { |x| x.destroy }
  end

  after(:all) do
    @xbmc.destroy
  end

  it "should filter all tv shows by current xbmc config, order_dir 'ASC', order 'sorttitle'" do
    man_tvshows = Tvshow.find(:all, :conditions => {:xbmc_id => @xbmc.object}, :order => :sorttitle, :orderdir => 'ASC')

    fil_tvshows = @test_class.filter_tvshows_xbmc({}, :sorttitle, 'ASC')

    fil_tvshows.length.should == man_tvshows.length
    (fil_tvshows[0].to_s == man_tvshows[0].to_s).should == true
    (fil_tvshows[1].to_s == man_tvshows[1].to_s).should == true
    (fil_tvshows[2].to_s == man_tvshows[2].to_s).should == true
    (fil_tvshows[3].to_s == man_tvshows[3].to_s).should == true
    (fil_tvshows[4].to_s == man_tvshows[4].to_s).should == true
  end

  it "should filter all tv shows by current xbmc config, order_dir 'DESC', order 'sorttitle'" do
    man_tvshows = Tvshow.find(:all, :conditions => {:xbmc_id => @xbmc.object}, :order => :sorttitle, :orderdir => 'DESC')

    fil_tvshows = @test_class.filter_tvshows_xbmc({}, :sorttitle, 'DESC')

    fil_tvshows.length.should == man_tvshows.length
    (fil_tvshows[0].to_s == man_tvshows[0].to_s).should == true
    (fil_tvshows[1].to_s == man_tvshows[1].to_s).should == true
    (fil_tvshows[2].to_s == man_tvshows[2].to_s).should == true
    (fil_tvshows[3].to_s == man_tvshows[3].to_s).should == true
    (fil_tvshows[4].to_s == man_tvshows[4].to_s).should == true
  end

  it "should only get the tv show with XBMC tv show ID '4'" do
    found = @test_class.find_tvshow(4)
    found.xlib_id.should == 4
  end

  it "should not find any tv shows with XBMC tv show ID '999'" do
    found = @test_class.find_tvshow(999)
    found.should be_nil
  end

  it "should add new tv show" do
    # Make sure it's not in the database.
    found = Tvshow.find(:all, :conditions => {:xlib_id => 100})
    found.length.should == 0

    # Create new tv show with tv show ID 100 in XBMC Format (hash)
    new_tvshow = {
      :tvshowid => 100,
      :label => "Test",
      :thumbnail => "Test",
      :fanart => "Test",
      :imdbnumber => "Test",
      :plot => "Test",
      :rating => 5,
      :genre => "test",
      :year => 2000,
      :playcount => 0,
      :studio => "Test",
      :title => "test"
    }
    # Needs to be in an array
    n_shows = [new_tvshow]
    
    @test_class.handle_new_tvshows(n_shows).should == true

    # Usings :all to make sure that only one result is found.
    found = Tvshow.find(:all, :conditions => {:xlib_id => 100})
    found.length.should == 1
    found[0].xlib_id.should == 100
  end

  it "should not add new tv show with same ID" do
    # Make sure that the tv show is already in the DB.
    found = Tvshow.find(:all, :conditions => {:xlib_id => 5})
    found.length.should == 1
    found[0].xlib_id.should == 5

    # Create new tv show with tv show ID 5 in XBMC Format (hash)
    new_tvshow = {
      :tvshowid => 5,
      :label => "Test",
      :thumbnail => "Test",
      :fanart => "Test",
      :imdbnumber => "Test",
      :plot => "Test",
      :rating => 5,
      :genre => "test",
      :year => 2000,
      :playcount => 0,
      :studio => "Test",
      :title => "test"
    }
    # Needs to be in an array
    n_shows = [new_tvshow]
    
    @test_class.handle_new_tvshows(n_shows).should == false

    # Usings :all to make sure that only one result is found.
    found = Tvshow.find(:all, :conditions => {:xlib_id => 5})
    found.length.should == 1
    found[0].xlib_id.should == 5
  end

  it "should only get tv shows with active XBMC" do 
    # Create non active XBMC
    temp_xbmc = XbmcConfig.create(
      :name => "Test", 
      :url => "localhost",
      :port => 8080, 
      :usrname => "xbmc", 
      :password => "xbmc", 
      # Note active is false
      :active => "false", 
      :version => "4")
    # Create some temp tv shows.
    (1..3).each do | num |
      Tvshow.create(
        :xbmc_id => temp_xbmc.object,
        :xlib_id => num + 10,
        :title => "An Test",
        :label => "test",
        :thumb => "test",
        :fanart => "test",
        :plot => "test",
        :tvdb => "test",
        :rating => 9.9,
        :year => 2009)
    end

    all_tvshows = Tvshow.find(:all)
    found = @test_class.get_tvshows_xbmc

    all_tvshows.length.should == 8
    found.length.should == 5
    found.each do |f_tvshow|
      f_tvshow.xbmc_id.to_f.should == @xbmc.object.to_f
    end
  end

  it "should remove tv show from DB which isn't in XBMC" do
    # Create new tv show with tv show ID 150 in XBMC Format (hash)
    new_tvshow = {
      :tvshowid => 150,
      :label => "Test",
      :thumbnail => "Test",
      :fanart => "Test",
      :imdbnumber => "Test",
      :plot => "Test",
      :rating => 5,
      :genre => "test",
      :year => 2000,
      :playcount => 0,
      :studio => "Test",
      :title => "test"
    }
    # Needs to be in an array
    n_shows = [new_tvshow]
    # Add it to the database
    @test_class.handle_new_tvshows(n_shows)

    # Remove ALL other tv shows apart from the new "list"
    @test_class.handle_removed_tvshows(n_shows).should == true

    found = Tvshow.find(:all)
    found.length.should == 1
    found[0].xlib_id.should == 150
  end

  it "should not remove tv show from DB which isn't in XBMC" do
    # Delete all tv show 
    Tvshow.find(:all).each {|x| x.destroy}

    # Create new tv show with tv show ID 151 in XBMC Format (hash)
    new_tvshow = {
      :tvshowid => 151,
      :label => "Test",
      :thumbnail => "Test",
      :fanart => "Test",
      :imdbnumber => "Test",
      :plot => "Test",
      :rating => 5,
      :genre => "test",
      :year => 2000,
      :playcount => 0,
      :studio => "Test",
      :title => "test"
    }
    # Needs to be in an array
    n_shows = [new_tvshow]
    # Add it to the database
    @test_class.handle_new_tvshows(n_shows)

    # Should only be one tv show
    found = Tvshow.find(:all)
    found.length.should == 1

    # Should not remove any tv show.
    @test_class.handle_removed_tvshows(n_shows).should == false

    # There still should only be one tv show.
    found = Tvshow.find(:all)
    found.length.should == 1
    found[0].xlib_id.should == 151
  end

end
