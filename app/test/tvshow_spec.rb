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
      :tvdb => "test",
      :plot => "test",
      :rating => 9.9,
      :year => 200,
      :sorttitle => "test",
      :url => "Test",
      :l_thumb => "test",
      :l_fanart => "test",
      :genre => "test",
      :playcount => 1,
      :studio => "test")

    @tvshow.valid?.should == true
  end
end