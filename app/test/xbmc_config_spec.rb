describe "XbmcConfig" do
  
  it "should save with normal data" do
    xbmc = XbmcConfig.new :name => "Test", :url => "localhost", :port => 8080, :usrname => "xbmc", :password => "xbmc", :active => true
    
    xbmc.save == true
  end

  it "should be active" do
    xbmc = XbmcConfig.new :name => "Test", :url => "localhost", :port => 8080, :usrname => "xbmc", :password => "xbmc", :active => true
    xbmc.save
    
    xbmc.is_active?.should == true
  end
  
  it "should fail with no name" do
    xbmc = XbmcConfig.new :url => "localhost", :port => 8080, :usrname => "xbmc", :password => "xbmc", :active => true
    
    xbmc.valid?.should == false
  end
  
  it "should fail with no url" do
    xbmc = XbmcConfig.new :name => "Test", :port => 8080, :usrname => "xbmc", :password => "xbmc", :active => true
    
    xbmc.valid?.should == false
  end
  
  it "should fail with no port" do
    xbmc = XbmcConfig.new :url => "localhost", :name => "test", :usrname => "xbmc", :password => "xbmc", :active => true
    
    xbmc.valid?.should == false
  end
  
  it "should fail with no username" do
    xbmc = XbmcConfig.new :url => "localhost", :port => 8080, :name => "test", :password => "xbmc", :active => true
    
    xbmc.valid?.should == false
  end
  
  it "should fail with text in port" do
    xbmc = XbmcConfig.new :name => "test", :url => "localhost", :port => "NOTNUM", :usrname => "xbmc", :password => "xbmc", :active => true
    
    xbmc.valid?.should == false
  end
  
end