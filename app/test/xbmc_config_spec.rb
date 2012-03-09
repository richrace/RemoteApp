describe "XbmcConfig" do
  
  before(:all) do
    Rhom::Rhom.database_full_reset
  end
  
  after :each do
    @xbmc.destroy 
  end

  it "should be valid with REQUIRED data" do
    @xbmc = XbmcConfig.new(
      :name => "Test", 
      :url => "localhost", 
      :port => 8080, 
      :usrname => "xbmc")
    
    @xbmc.valid?.should == true
  end

  it "should be valid with all data" do
    @xbmc = XbmcConfig.new(
      :name => "Test", 
      :url => "localhost", 
      :port => 8080, 
      :usrname => "xbmc", 
      :password => "xbmc", 
      :active => "true", 
      :version => 2)
    
    @xbmc.valid?.should == true
  end
  
  it "should fail with no name" do
    @xbmc = XbmcConfig.new(
      :url => "localhost", 
      :port => 8080, 
      :usrname => "xbmc", 
      :password => "xbmc", 
      :active => "true")
    
    @xbmc.valid?.should == false
  end
  
  it "should fail with no url" do
    @xbmc = XbmcConfig.new(
      :name => "Test", 
      :port => 8080, 
      :usrname => "xbmc", 
      :password => "xbmc", 
      :active => "true")
    
    @xbmc.valid?.should == false
  end
  
  it "should fail with no port" do
    @xbmc = XbmcConfig.new(
      :url => "localhost", 
      :name => "test", 
      :usrname => "xbmc", 
      :password => "xbmc", 
      :active => "true")
    
    @xbmc.valid?.should == false
  end
  
  it "should fail with no username" do
    @xbmc = XbmcConfig.new(
      :url => "localhost", 
      :port => 8080, 
      :name => "test", 
      :password => "xbmc", 
      :active => "true")
    
    @xbmc.valid?.should == false
  end
  
  it "should fail with text in port" do
    @xbmc = XbmcConfig.new(
      :name => "test", 
      :url => "localhost", 
      :port => "NOTNUM", 
      :usrname => "xbmc", 
      :password => "xbmc", 
      :active => "true")
    
    @xbmc.valid?.should == false
  end

  it "should fail with float in port" do
    @xbmc = XbmcConfig.new(
      :name => "test", 
      :url => "localhost", 
      :port => 23.23, 
      :usrname => "xbmc", 
      :password => "xbmc", 
      :active => "true")
    
    @xbmc.valid?.should == false
  end

  it "should fail with text in version" do
    @xbmc = XbmcConfig.new(
      :name => "test", 
      :url => "localhost", 
      :port => 8080, 
      :usrname => "xbmc", 
      :password => "xbmc", 
      :active => "true", 
      :version => "NOTNUM")
    
    @xbmc.valid?.should == false
  end

  it "should fail with float in version" do
    @xbmc = XbmcConfig.new(
      :name => "test", 
      :url => "localhost", 
      :port => 8080, 
      :usrname => "xbmc", 
      :password => "xbmc", 
      :active => "true", 
      :version => 2.23)
    
    @xbmc.valid?.should == false
  end

  it "should be active" do
    @xbmc = XbmcConfig.create(
      :name => "Test", 
      :url => "localhost", 
      :port => 8080, 
      :usrname => "xbmc", 
      :password => "xbmc", 
      :active => "true")

    @xbmc.is_active?.should == true
  end
  
  it "should not be active" do
    @xbmc = XbmcConfig.create(
      :name => "Test", 
      :url => "localhost", 
      :port => 8080, 
      :usrname => "xbmc", 
      :password => "xbmc", 
      :active => "false")

    @xbmc.is_active?.should == false
  end
end
