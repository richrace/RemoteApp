describe "Tvshow" do
  #this test always fails, you really should have tests!

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
end