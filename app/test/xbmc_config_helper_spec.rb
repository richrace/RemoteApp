describe "XbmcConfigHelper" do
  
  before(:all) do
    Rhom::Rhom.database_full_reset
  end
  
  before(:each) do
    @xbmc = XbmcConfig.create :name => "Test", :url => "localhost", :port => 8080, :usrname => "xbmc", :password => "xbmc", :active => "true"
  end
  
  after(:each) do
    @xbmc.destroy
  end
  
  
  it "should have a current config" do
    XbmcConfigHelper.current_config.nil?.should == false
  end
  
  it "Should not have a current config" do
    @xbmc.active = "false"
    @xbmc.save
    XbmcConfigHelper.current_config.nil?.should == true
  end
  
end