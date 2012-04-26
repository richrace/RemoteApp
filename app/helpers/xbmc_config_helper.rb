# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'helpers/xbmc/xbmc_connect'

# Helper for finding the current Active configuration.
module XbmcConfigHelper
  
  class << self
    
    # Finds the current active XBMC Configuration and calls the XbmcConnect.setup method
    # to make sure the correct Networking details are added.
    # Returns the found XBMC Configuration 
    def current_config
      xbmc_config = XbmcConfig.find(:first, :conditions => {:active => true})
      
      unless xbmc_config.nil? 
        XbmcConnect.setup(xbmc_config.url, xbmc_config.port, xbmc_config.usrname, xbmc_config.password)
      end
      
      return xbmc_config
    end
  
  end
end