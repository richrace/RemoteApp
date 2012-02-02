
describe "ErrorHelper" do
  
  class TempClass
  end
  
  before(:all) do
    Rhom::Rhom.database_full_reset
  end
  
  before(:each) do
    @test_class = TempClass.new
    @test_class.extend(ErrorHelper)
    @xbmc = XbmcConfig.create :name => "Test", :url => "localhost", :port => 8080, :usrname => "xbmc", :password => "xbmc", :active => "true"
  end
  
  after(:each) do
    @xbmc.destroy
  end
  
  it "Should have no config" do
    @xbmc.active = "false";
    @xbmc.save
    @test_class.error_handle.should == "no config"
  end
  
  it "Should have no api" do
    @test_class.error_handle.should == "no api"
  end
  
  it "Should be an http error 401" do
    @test_class.error_handle({'http_error' => '401'}).should == "http 401"
  end
  
  it "Should be an http error 404" do
    @test_class.error_handle({'http_error' => '404'}).should == "http 404"
  end

end