require 'helpers/xbmc/apis/xbmc_apis'
require 'helpers/xbmc_config_helper'

module CommandsHelper
  include XbmcConfigHelper
  
  def scan_video_lib(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == Api::V2::VERSION
        Api::V2::VideoLibrary.scan(callback)
      elsif (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::VideoLibrary.scan(callback)
      end
    end
  end
  
end