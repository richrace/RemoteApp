# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licencerequire 'helpers/xbmc/apis/xbmc_apis'

# Module that contains some functions for the
# the Video Library for XBMC JSON RPC API Version 2
module VideoLibrary2
  
  # Scans the video library
  def scan(callback)
    XbmcConnect::VideoLibrary.scan_for_content(callback)
  end
  
  # Cleans the VideoLibrary
  def get_movies(callback)
    XbmcConnect::VideoLibrary.get_movies(callback)
  end
  
end