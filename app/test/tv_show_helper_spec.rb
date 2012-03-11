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

end