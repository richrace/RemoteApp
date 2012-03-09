describe "Tvseason" do
  #this test always fails, you really should have tests!

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
end