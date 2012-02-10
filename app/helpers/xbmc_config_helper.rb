require 'helpers/xbmc/xbmc_connect'

module XbmcConfigHelper
  
  class << self
  
  def current_config
    xbmc_config = XbmcConfig.find(:first, :conditions => {:active => true})
    
    unless xbmc_config.nil? 
      XbmcConnect.setup(xbmc_config.url, xbmc_config.port, xbmc_config.usrname, xbmc_config.password)
    end
    
    return xbmc_config
  end
end
end