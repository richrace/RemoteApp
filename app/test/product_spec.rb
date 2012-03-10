describe "Product" do
  
  before(:all) do
    Rhom::Rhom.database_full_reset
    @xbmc = XbmcConfig.create(
      :name => "Test", 
      :url => "localhost", 
      :port => 8080, 
      :usrname => "xbmc", 
      :password => "xbmc", 
      :active => "true")
  end

  it "should have not be valid with no title and with xbmc id" do
    @product = Product.new(:xbmc_id => @xbmc.object)

    @product.valid?.should == false
  end

  it "should be valid with title and xbmc id" do
    @product = Product.new(
      :title => "Test", 
      :xbmc_id => @xbmc.object)

    @product.valid?.should == true
  end

  it "should not be valid without title and xbmc id" do
    @product = Product.new

    @product.valid?.should == false
  end

  it "" do
    @product = Product.new(
      :title => "Test",
      :xbmc_id => "NOTNUM")

    @product.valid?.should == false
  end

end
