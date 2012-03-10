describe "Tvseason" do

  it "tvseason should be valid with all fields" do
    @season = Tvseason.new(
      :xbmc_id => 213,
      :xlib_id => 2,
      :tvshow_id => 2, 
      :label => "test",
      :showtitle => "Test",
      :thumb => "Test",
      :fanart => "test",
      :l_thumb => "Test",
      :l_fanart => "test",
      :url => "test")

    @season.valid?.should == true
  end

  it "tvseason should be valid with REQUIRED fields" do
    @season = Tvseason.new(
      :xbmc_id => 213,
      :xlib_id => 2,
      :tvshow_id => 2, 
      :label => "test",
      :showtitle => "Test",
      :thumb => "Test",
      :fanart => "test")

    @season.valid?.should == true
  end

  it "tvseason shouldn't be valid with incorrect type xbmc_id" do
    @season = Tvseason.new(
      :xbmc_id => "NOTNUM",
      :xlib_id => 2,
      :tvshow_id => 2, 
      :label => "test",
      :showtitle => "Test",
      :thumb => "Test",
      :fanart => "test")

    @season.valid?.should == false
  end

  it "tvseason shouldn't be valid with incorrect type xlib_id (string)" do
    @season = Tvseason.new(
      :xbmc_id => 213,
      :xlib_id => "NOTNUM",
      :tvshow_id => 2, 
      :label => "test",
      :showtitle => "Test",
      :thumb => "Test",
      :fanart => "test")

    @season.valid?.should == false
  end

  it "tvseason shouldn't be valid with incorrect type xlib_id (float)" do
    @season = Tvseason.new(
      :xbmc_id => 213,
      :xlib_id => 2.5,
      :tvshow_id => 2, 
      :label => "test",
      :showtitle => "Test",
      :thumb => "Test",
      :fanart => "test")

    @season.valid?.should == false
  end

  it "tvseason shouldn't be valid with incorrect type tvshow_id (string)" do
    @season = Tvseason.new(
      :xbmc_id => 213,
      :xlib_id => 2,
      :tvshow_id => "NOTNUM", 
      :label => "test",
      :showtitle => "Test",
      :thumb => "Test",
      :fanart => "test")

    @season.valid?.should == false
  end

  it "tvseason shouldn't be valid with incorrect type tvshow_id (float)" do
    @season = Tvseason.new(
      :xbmc_id => 213,
      :xlib_id => 2,
      :tvshow_id => 2.5, 
      :label => "test",
      :showtitle => "Test",
      :thumb => "Test",
      :fanart => "test")

    @season.valid?.should == false
  end

  it "tvseason shouldn't be valid with missing xbmc_id" do
    @season = Tvseason.new(
      :xlib_id => 2,
      :tvshow_id => 2, 
      :label => "test",
      :showtitle => "Test",
      :thumb => "Test",
      :fanart => "test")

    @season.valid?.should == false
  end

  it "tvseason shouldn't be valid with missing xlib_id" do
    @season = Tvseason.new(
      :xbmc_id => 213,
      :tvshow_id => 2, 
      :label => "test",
      :showtitle => "Test",
      :thumb => "Test",
      :fanart => "test")

    @season.valid?.should == false
  end

  it "tvseason shouldn't be valid with missing tvshow_id" do
    @season = Tvseason.new(
      :xbmc_id => 213,
      :xlib_id => 2,
      :label => "test",
      :showtitle => "Test",
      :thumb => "Test",
      :fanart => "test")

    @season.valid?.should == false
  end

  it "tvseason shouldn't be valid with missing label" do
    @season = Tvseason.new(
      :xbmc_id => 213,
      :xlib_id => 2,
      :tvshow_id => 2, 
      :showtitle => "Test",
      :thumb => "Test",
      :fanart => "test")

    @season.valid?.should == false
  end

  it "tvseason shouldn't be valid with missing showtitle" do
    @season = Tvseason.new(
      :xbmc_id => 213,
      :xlib_id => 2,
      :tvshow_id => 2, 
      :label => "test",
      :thumb => "Test",
      :fanart => "test")

    @season.valid?.should == false
  end

  it "tvseason shouldn't be valid with missing thumb" do
    @season = Tvseason.new(
      :xbmc_id => 213,
      :xlib_id => 2,
      :tvshow_id => 2, 
      :label => "test",
      :showtitle => "Test",
      :fanart => "test")

    @season.valid?.should == false
  end

  it "tvseason shouldn't be valid with missing fanart" do
    @season = Tvseason.new(
      :xbmc_id => 213,
      :xlib_id => 2,
      :tvshow_id => 2, 
      :label => "test",
      :showtitle => "Test",
      :thumb => "Test")

    @season.valid?.should == false
  end

  it "tvseason should be able to delete image" do
    @season = Tvseason.create(
      :xbmc_id => 213,
      :xlib_id => 2,
      :tvshow_id => 2, 
      :label => "test",
      :showtitle => "Test",
      :thumb => "Test",
      :fanart => "test")

    # Create test file
    file = File.join(Rho::RhoApplication::get_base_app_path(), "test.jpg")
    File.new(file, "w+")
    # Check file has been created
    File.exists?(file).should == true
    # Assign file to TV Season
    @season.l_thumb = file
    @season.save
    # Delete the TV Season image
    @season.destroy_image
    # Check that the path has been reset
    @season.l_thumb.should be_nil
    # Check that the file has been deleted.
    File.exists?(file).should == false
  end

end
