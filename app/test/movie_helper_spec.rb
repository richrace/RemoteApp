require 'helpers/movie_helper'

describe "MovieHelper" do

  class TempClass
  end

  before(:all) do
    Rhom::Rhom.database_full_reset
    @test_class = TempClass.new
    @test_class.extend(MovieHelper)

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
    @org_movies = []
    (1..5).each do |num|
      tmp_movie = Movie.create(
        :xbmc_id => @xbmc.object,
        :xlib_id => num,
        :title => "Test #{num}",
        :label => "test",
        :thumb => "test",
        :fanart => "test",
        :imdbnumber => "test",
        :plot => "test",
        :rating => 9.9,
        :trailer => "test",
        :year => 200)
      tmp_movie.create_sort_title
      @org_movies << tmp_movie
    end
  end

  after(:each) do
    Movie.find(:all).each do |m|
      m.destroy
    end
    @org_movies.clear
  end

  after(:all) do
    @xbmc.destroy
  end

  it "should get all movies filtered by xbmc, order_dir 'ASC', order 'sorttitle' " do
    fil_movies = @test_class.filter_movies_xbmc({}, :sorttitle, 'ASC')

    man_movies = Movie.find(:all, :conditions => {:xbmc_id => @xbmc.object}, :order => :sorttitle, :orderdir => 'ASC')

    (fil_movies[0].to_s == man_movies[0].to_s).should == true
    (fil_movies[1].to_s == man_movies[1].to_s).should == true
    (fil_movies[2].to_s == man_movies[2].to_s).should == true
    (fil_movies[3].to_s == man_movies[3].to_s).should == true
    (fil_movies[4].to_s == man_movies[4].to_s).should == true
  end

end
