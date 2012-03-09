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

  it "should not be valid with missing xbmc id" do
    @movie = Movie.new(
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

    @movie.valid?.should == false
  end

  it "should not be valid with missing xlib_id" do
    @movie = Movie.new(
      :xbmc_id => 223,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200)

    @movie.valid?.should == false
  end

  it "should not be valid with missing title" do
    @movie = Movie.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200)

    @movie.valid?.should == false
  end

  it "should not be valid with missing label" do
    @movie = Movie.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200)

    @movie.valid?.should == false
  end

  it "should not be valid with missing thumb" do
    @movie = Movie.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200)

    @movie.valid?.should == false
  end
  
  it "should not be valid with missing fanart" do
    @movie = Movie.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200)

    @movie.valid?.should == false
  end

  it "should not be valid with missing imdbnumber" do
    @movie = Movie.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200)

    @movie.valid?.should == false
  end

  it "should not be valid with missing plot" do
    @movie = Movie.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200)

    @movie.valid?.should == false
  end

  it "should not be valid with missing rating" do
    @movie = Movie.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :trailer => "test",
      :year => 200)

    @movie.valid?.should == false
  end

  it "should not be valid with missing trailer" do
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
      :year => 200)

    @movie.valid?.should == false
  end

  it "should not be valid with missing year" do
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
      :trailer => "test")

    @movie.valid?.should == false
  end

  it "should not be valid with incorrect type for XBMC Config ID" do
    @movie = Movie.new(
      :xbmc_id => "22sd",
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

    @movie.valid?.should == false
  end

  it "should not be valid with incorrect type for xlib_id (string)" do
    @movie = Movie.new(
      :xbmc_id => 222,
      :xlib_id => "222sdfds",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200)

    @movie.valid?.should == false
  end

  it "should not be valid with incorrect type for xlib_id (float)" do
    @movie = Movie.new(
      :xbmc_id => 222,
      :xlib_id => 22.23,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200)

    @movie.valid?.should == false
  end

  it "should not be valid with incorrect type for rating (string)" do
    @movie = Movie.new(
      :xbmc_id => 222,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => "9.9 r",
      :trailer => "test",
      :year => 200)

    @movie.valid?.should == false
  end

  it "should not be valid with incorrect type for year (string)" do
    @movie = Movie.new(
      :xbmc_id => 222,
      :xlib_id => 22.23,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => "year 200")

    @movie.valid?.should == false
  end

  it "should not be valid with incorrect type for year (float)" do
    @movie = Movie.new(
      :xbmc_id => 222,
      :xlib_id => 22.23,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200.23)

    @movie.valid?.should == false
  end

  it "should not be valid with incorrect type for playcount (float)" do
    @movie = Movie.new(
      :xbmc_id => 222,
      :xlib_id => 22.23,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200,
      :playcount => 2.5)

    @movie.valid?.should == false
  end

  it "should not be valid with incorrect type for playcount (string)" do
    @movie = Movie.new(
      :xbmc_id => 222,
      :xlib_id => 22.23,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :imdbnumber => "test",
      :plot => "test",
      :rating => 9.9,
      :trailer => "test",
      :year => 200,
      :playcount => "one")

    @movie.valid?.should == false
  end

end