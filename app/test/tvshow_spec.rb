describe "Tvshow" do

  it "tvshow should be valid with all fields" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :year => 2009,
      :rating => 9.9,
      :sorttitle => "test",
      :url => "Test",
      :l_thumb => "test",
      :l_fanart => "test",
      :playcount => 1,
      :studio => "test",
      :genre => "test")

    @tvshow.valid?.should == true
  end

  it "tvshow should be valid with REQUIRED fields" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009)

    @tvshow.valid?.should == true
  end

  it "tvshow should be invalid with missing xbmc id" do
    @tvshow = Tvshow.new(
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009)

    @tvshow.valid?.should == false
  end

  it "tvshow should be invalid with missing xlib_id" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009)

    @tvshow.valid?.should == false
  end

  it "tvshow should be invalid with missing title" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009)

    @tvshow.valid?.should == false
  end

  it "tvshow should be invalid with missing label" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009)

    @tvshow.valid?.should == false
  end

  it "tvshow should be invalid with missing thumb" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009)

    @tvshow.valid?.should == false
  end

  it "tvshow should be invalid with missing fanart" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009)

    @tvshow.valid?.should == false
  end

  it "tvshow should be invalid with missing plot" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009)

    @tvshow.valid?.should == false
  end

  it "tvshow should be invalid with missing tvdb" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9,
      :year => 2009)

    @tvshow.valid?.should == false
  end

  it "tvshow should be invalid with missing rating" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :year => 2009)

    @tvshow.valid?.should == false
  end

  it "tvshow should be invalid with missing year" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9)

    @tvshow.valid?.should == false
  end

  it "tvshow should be invalid with incorrect type for xbmc_id" do
    @tvshow = Tvshow.new(
      :xbmc_id => "NOTNUM",
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009)

    @tvshow.valid?.should == false
  end

  it "tvshow should be invalid with incorrect type for xlib_id (string)" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :xlib_id => "NOTNUM",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009)

    @tvshow.valid?.should == false
  end

  it "tvshow should be invalid with incorrect type for xlib_id (float)" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :xlib_id => 222.23,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009)

    @tvshow.valid?.should == false
  end

  it "tvshow should be invalid with incorrect type for rating" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => "NOTNUM",
      :year => 2009)

    @tvshow.valid?.should == false
  end

  it "tvshow should be invalid with incorrect type for year (string)" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => "NOTNUM")

    @tvshow.valid?.should == false
  end

  it "tvshow should be invalid with incorrect type for year (float)" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009.5)

    @tvshow.valid?.should == false
  end

  it "tvshow should be invalid with incorrect type for playcount (string)" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009,
      :playcount => "NOTNUM")

    @tvshow.valid?.should == false
  end

  it "tvshow should be invalid with incorrect type for playcount (float)" do
    @tvshow = Tvshow.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009,
      :playcount => 1.5)

    @tvshow.valid?.should == false
  end

  it "should destroy image" do
    @tvshow = Tvshow.create(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009)

    # Create test file
    file = File.join(Rho::RhoApplication::get_base_app_path(), "test.jpg")
    File.new(file, "w+")
    # Check file has been created
    File.exists?(file).should == true
    # Assign file to TV Show
    @tvshow.l_thumb = file
    @tvshow.save
    # Delete the TV Show
    @tvshow.destroy_image
    # Check that the path has been reset
    @tvshow.l_thumb.should be_nil
    # Check that the file has been deleted.
    File.exists?(file).should == false
  end

  it "tvshow should create sorttitle with 'The' prefix" do
    @tvshow = Tvshow.create(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "The Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009)
    @tvshow.create_sort_title
    @tvshow.sorttitle.should_not == @tvshow.title
    @tvshow.sorttitle.should == "Test"
  end

  it "tvshow should create sorttitle with 'An' prefix" do
    @tvshow = Tvshow.create(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "An Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009)
    @tvshow.create_sort_title
    @tvshow.sorttitle.should_not == @tvshow.title
    @tvshow.sorttitle.should == "Test"
  end

  it "tvshow should create sorttitle with 'A' prefix" do
    @tvshow = Tvshow.create(
      :xbmc_id => 223,
      :xlib_id => 222,
      :title => "A Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :tvdb => "test",
      :rating => 9.9,
      :year => 2009)
    @tvshow.create_sort_title
    @tvshow.sorttitle.should_not == @tvshow.title
    @tvshow.sorttitle.should == "Test"
  end

end
