describe "Movie" do

  it "movie should be valid with all fields" do
    @movie = Movie.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200,
      :watch_later => false,
      :sorttitle => "test",
      :url => "Test",
      :l_thumb => "test",
      :l_fanart => "test",
      :genre => "test",
      :playcount => 1,
      :studio => "test",
      :director => "test")

    @movie.valid?.should == true
  end

  it "movie should be valid with all REQUIRED fields" do
    @movie = Movie.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200)

    @movie.valid?.should == true
  end

  it "movie should not be in watch later list by default" do
    @movie = Movie.create(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200)

    @movie.watch_later?.should == false
  end

  it "movie should be in watch later list" do
    @movie = Movie.create(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200,
      :watch_later => "true")

    @movie.watch_later?.should == true
  end

  it "movie should create sorttitle with 'The' prefix" do
    @movie = Movie.create(
      :xbmc_id => 223,
      :xlib_id => 222,
      # Note the "The" prefix. This should be dropped.
      :title => "The Title", 
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200)
    @movie.create_sort_title
    @movie.sorttitle.should_not == @movie.title
  end

  it "movie should create sorttitle with 'An' prefix" do
    @movie = Movie.create(
      :xbmc_id => 223,
      :xlib_id => 222,
      # Note the "An" prefix. This should be dropped.
      :title => "An Title", 
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200)
    @movie.create_sort_title
    @movie.sorttitle.should_not == @movie.title
  end

  it "movie should create sorttitle with 'A' prefix" do
    @movie = Movie.create(
      :xbmc_id => 223,
      :xlib_id => 222,
      # Note the "A" prefix. This should be dropped.
      :title => "A Title", 
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200)
    @movie.create_sort_title
    @movie.sorttitle.should_not == @movie.title
  end

  it "should delete the image file in thumb" do
    @movie = Movie.create(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Title", 
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200)

    # Test file
    file = File.join(Rho::RhoApplication::get_base_app_path(), "test.jpg")
    @movie.l_thumb = file
    @movie.save
    @movie.destroy_image
    @movie.l_thumb.should be_nil
  end
end