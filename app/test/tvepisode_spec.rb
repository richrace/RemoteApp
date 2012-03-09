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
end