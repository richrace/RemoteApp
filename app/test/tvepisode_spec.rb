describe "Tvepisode" do

  it "tvepisode should be valid with all fields" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9,
      :url => "Test",
      :l_thumb => "test",
      :l_fanart => "test")

    @episode.valid?.should == true
  end

  it "tvepisode should be valid with REQUIRED fields" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == true
  end

  it "tvepisode shouldn't be valid with missing xbmc_id" do
    @episode = Tvepisode.new(
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with missing xlib_id" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with missing episode" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with missing firstaired" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with missing tvshow_id" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with missing tvshow_name" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with missing tvseason_id" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with missing runtime" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with missing title" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with missing label" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with missing thumb" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with missing fanart" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with missing plot" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with missing rating" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test")

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with incorrect type for xbmc_id" do
    @episode = Tvepisode.new(
      :xbmc_id => "NOTNUM",
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with incorrect type for xlib_id (string)" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => "NOTNUM",
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with incorrect type for xlib_id (float)" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222.5,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with incorrect type for episode (string)" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => "NOTNUM",
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with incorrect type for episode (float)" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2.5,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with incorrect type for tvshow_id (string)" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => "NOTNUM",
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with incorrect type for tvshow_id (float)" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321.3,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with incorrect type for tvseason_id (string)" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => "NOTNUM",
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with incorrect type for tvseason_id (float)" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1.5,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)

    @episode.valid?.should == false
  end

  it "tvepisode shouldn't be valid with incorrect type for rating" do
    @episode = Tvepisode.new(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => "NOTNUM")

    @episode.valid?.should == false
  end

  it "tvepisode should be able to delete image" do
    @episode = Tvepisode.create(
      :xbmc_id => 223,
      :xlib_id => 222,
      :episode => 2,
      :firstaired => "2/3/2001",
      :tvshow_id => 321,
      :tvshow_name => "Test",
      :tvseason_id => 1,
      :runtime => "test",
      :title => "Test",
      :label => "test",
      :thumb => "test",
      :fanart => "test",
      :plot => "test",
      :rating => 9.9)
    
    # Create test file
    file = File.join(Rho::RhoApplication::get_base_app_path(), "test.jpg")
    File.new(file, "w+")
    # Check file has been created
    File.exists?(file).should == true
    # Assign file to TV Episode
    @episode.l_thumb = file
    @episode.save
    # Delete the TV Episode image
    @episode.destroy_image
    # Check that the path has been reset
    @episode.l_thumb.should be_nil
    # Check that the file has been deleted.
    File.exists?(file).should == false
  end

end
