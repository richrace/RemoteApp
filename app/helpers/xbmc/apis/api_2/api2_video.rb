require 'helpers/xbmc/apis/xbmc_apis'

module VideoLibrary2
  
  def scan(callback)
    XbmcConnect::VideoLibrary.scan_for_content(callback)
  end
  
  def get_movies(callback)
    XbmcConnect::VideoLibrary.get_movies(callback)
  end
  
end