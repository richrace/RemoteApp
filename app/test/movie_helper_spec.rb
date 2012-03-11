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
    end
  end

  after(:each) do
    Movie.find(:all).each do |m|
      m.destroy
    end
  end

  after(:all) do
    @xbmc.destroy
  end

  it "should get all movies filtered by xbmc, order_dir 'ASC', order 'sorttitle' " do
    fil_movies = @test_class.filter_movies_xbmc({}, :sorttitle, 'ASC')

    man_movies = Movie.find(:all, :conditions => {:xbmc_id => @xbmc.object}, :order => :sorttitle, :orderdir => 'ASC')

    # Makes sure each item is in the correct place in the list. For some
    # bizarre reason need to convert to string to get the compare method
    # to work properly. If you take the output and put it into IRB and  
    # compare, it comes out true.
    (fil_movies[0].to_s == man_movies[0].to_s).should == true
    (fil_movies[1].to_s == man_movies[1].to_s).should == true
    (fil_movies[2].to_s == man_movies[2].to_s).should == true
    (fil_movies[3].to_s == man_movies[3].to_s).should == true
    (fil_movies[4].to_s == man_movies[4].to_s).should == true
  end

  it "should get movie with xlib_id 2 via filter_movies_xbmc" do
    found = @test_class.filter_movies_xbmc({:xlib_id => 2}, :sorttitle, 'ASC', :first)

    expect = Movie.find(:first, :conditions => {:xbmc_id => @xbmc.object, :xlib_id => 2}, :order => :sorttitle, :orderdir => 'ASC')

    (found.to_s == expect.to_s).should == true
  end

  it "should get all movies filtered by xbmc, order_dir 'DESC', order 'sorttitle' " do
    fil_movies = @test_class.filter_movies_xbmc({}, :sorttitle, 'DESC')

    man_movies = Movie.find(:all, :conditions => {:xbmc_id => @xbmc.object}, :order => :sorttitle, :orderdir => 'DESC')

    (fil_movies[0].to_s == man_movies[0].to_s).should == true
    (fil_movies[1].to_s == man_movies[1].to_s).should == true
    (fil_movies[2].to_s == man_movies[2].to_s).should == true
    (fil_movies[3].to_s == man_movies[3].to_s).should == true
    (fil_movies[4].to_s == man_movies[4].to_s).should == true
  end

  it "should get 'test 4' movie using search_by_title lower case" do
    found = @test_class.search_by_title('test 4')

    # Should only find one title
    found.length.should == 1
    # Make sure they are lower case
    (found[0].title.downcase == 'test 4').should == true
  end

  it "should get 'test 4' movie using search_by_title upper case" do
    found = @test_class.search_by_title('TEST 4')

    # Should only find one title
    found.length.should == 1
    # Make sure they are lower case
    (found[0].title.upcase == 'TEST 4').should == true
  end

  it "should get no movies using search_by_title just passing 'test'" do
    found = @test_class.search_by_title('test')

    found.length.should == 0
  end

  it "should get 'test 4' using 'test-4' as searching title" do
    found = @test_class.search_by_title('test-4')

    # Should only find one title
    found.length.should == 1
    # Make sure they are lower case
    (found[0].title.downcase == 'test 4').should == true
  end

  it "should get 'test-6' using 'test 6' as searching title" do
    # Create new Movie just for this test. Note title
    Movie.create(
      :xbmc_id => @xbmc.object,
      :xlib_id => 6,
      :title => "Test-6",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200)
    found = @test_class.search_by_title('test 6')

    # Should only find one title
    found.length.should == 1
    # Make sure they are lower case
    (found[0].title.downcase == 'test-6').should == true
  end

  it "should get 'test 4' using 'test 4 DVD' as searching title" do
    found = @test_class.search_by_title('test 4 DVD')

    # Should only find one title
    found.length.should == 1
    # Make sure they are lower case
    (found[0].title.downcase == 'test 4').should == true
  end

  it "should get 'test 4' using 'DVD test 4' as searching title" do
    found = @test_class.search_by_title('DVD test 4')

    # Should only find one title
    found.length.should == 1
    # Make sure they are lower case
    (found[0].title.downcase == 'test 4').should == true
  end

  it "should only get movies with active XBMC" do 
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
    # Create some temp Movies.
    (1..3).each do | num |
      tmp_movie = Movie.create(
        :xbmc_id => temp_xbmc.object,
        # Use ID and name from 11-13 (inclusive)
        :xlib_id => num + 10,
        :title => "Test #{num+10}",
        :label => "test",
        :thumb => "test",
        :fanart => "test",
        :imdbnumber => "test",
        :plot => "test",
        :rating => 9.9,
        :trailer => "test",
        :year => 200)
    end

    all_movies = Movie.find(:all)
    found = @test_class.get_movies_xbmc

    all_movies.length.should == 8
    found.length.should == 5
    found.each do |f_movie|
      f_movie.xbmc_id.to_f.should == @xbmc.object.to_f
    end
  end

  it "should only get the movie with XBMC Movie ID '4'" do
    found = @test_class.find_movie(4)
    found.xlib_id.should == 4
  end

  it "should not find any movie with XBMC Movie ID '999'" do
    found = @test_class.find_movie(999)
    found.should be_nil
  end

  it "should add new movie" do
    # Make sure it's not in the database.
    found = Movie.find(:all, :conditions => {:xlib_id => 100})
    found.length.should == 0

    # Create new movie with Movie ID 100 in XBMC Format (hash)
    new_movie = {
      :movieid => 100,
      :label => "Test",
      :thumbnail => "Test",
      :fanart => "Test",
      :imdbnumber => "Test",
      :plot => "Test",
      :trailer => 'videoid=SADsadsaAS',
      :rating => 5,
      :genre => "test",
      :year => 2000,
      :playcount => 0,
      :studio => "Test",
      :title => "test",
      :director => "test"
    }
    # Needs to be in an array
    n_movies = [new_movie]
    
    @test_class.handle_new_movies(n_movies).should == true

    # Usings :all to make sure that only one result is found.
    found = Movie.find(:all, :conditions => {:xlib_id => 100})
    found.length.should == 1
    found[0].xlib_id.should == 100
  end

  it "should not add new movie with same ID" do
    # Make sure that the movie is already in the DB.
    found = Movie.find(:all, :conditions => {:xlib_id => 5})
    found.length.should == 1
    found[0].xlib_id.should == 5

    # Create new movie with Movie ID 5 in XBMC Format (hash)
    new_movie = {
      :movieid => 5,
      :label => "Test",
      :thumbnail => "Test",
      :fanart => "Test",
      :imdbnumber => "Test",
      :plot => "Test",
      :trailer => 'videoid=SADsadsaAS',
      :rating => 5,
      :genre => "test",
      :year => 2000,
      :playcount => 0,
      :studio => "Test",
      :title => "test",
      :director => "test"
    }
    # Needs to be in an array
    n_movies = [new_movie]
    
    @test_class.handle_new_movies(n_movies).should == false

    # Usings :all to make sure that only one result is found.
    found = Movie.find(:all, :conditions => {:xlib_id => 5})
    found.length.should == 1
    found[0].xlib_id.should == 5
  end

  it "should extract only youtube video ID for URL" do
    trailer_field = "plugin://plugin.video.youtube/?action=play_video&videoid=EEYqgyXyk9A"
    wanted_id = "EEYqgyXyk9A"
    @test_class.get_youtube_videoid(trailer_field).should == wanted_id
  end

  it "should return nil if format is incorrect" do
    trailer_field = "youtubeid=EEYqgyXyk9A"
    @test_class.get_youtube_videoid(trailer_field).should be_nil
  end

  it "should extract only youtube video ID only videoid param" do
    trailer_field = "videoid=EEYqgyXyk9A"
    wanted_id = "EEYqgyXyk9A"
    @test_class.get_youtube_videoid(trailer_field).should == wanted_id
  end

  it "should remove movie from DB which isn't in XBMC" do
    # Create new movie with Movie ID 150 in XBMC Format (hash)
    new_movie = {
      :movieid => 150,
      :label => "Test",
      :thumbnail => "Test",
      :fanart => "Test",
      :imdbnumber => "Test",
      :plot => "Test",
      :trailer => 'videoid=SADsadsaAS',
      :rating => 5,
      :genre => "test",
      :year => 2000,
      :playcount => 0,
      :studio => "Test",
      :title => "test",
      :director => "test"
    }
    # Needs to be in an array
    n_movies = [new_movie]
    # Add it to the database
    @test_class.handle_new_movies(n_movies)

    # Remove ALL other movies apart from the new "list"
    @test_class.handle_removed_movies(n_movies).should == true

    found = Movie.find(:all)
    found.length.should == 1
    found[0].xlib_id.should == 150
  end

  it "should not remove movies from DB which isn't in XBMC" do
    # Delete all movies
    Movie.find(:all).each {|x| x.destroy}

    # Create new movie with Movie ID 151 in XBMC Format (hash)
    new_movie = {
      :movieid => 151,
      :label => "Test",
      :thumbnail => "Test",
      :fanart => "Test",
      :imdbnumber => "Test",
      :plot => "Test",
      :trailer => 'videoid=SADsadsaAS',
      :rating => 5,
      :genre => "test",
      :year => 2000,
      :playcount => 0,
      :studio => "Test",
      :title => "test",
      :director => "test"
    }
    # Needs to be in an array
    n_movies = [new_movie]
    # Add it to the database
    @test_class.handle_new_movies(n_movies)

    # Should only be one movie
    found = Movie.find(:all)
    found.length.should == 1

    # Should not remove any movies.
    @test_class.handle_removed_movies(n_movies).should == false

    # There still should only be one movie.
    found = Movie.find(:all)
    found.length.should == 1
    found[0].xlib_id.should == 151
  end

end
