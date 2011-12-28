require 'helpers/xbmc/apis/xbmc_apis'

module VideoLibrary4
  
  def clean(callback)
    XbmcConnect::VideoLibrary.clean(callback)
  end
    
  def scan(callback)
    XbmcConnect::VideoLibrary.scan(callback)
  end
  
end