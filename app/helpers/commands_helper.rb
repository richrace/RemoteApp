require 'helpers/xbmc/apis/xbmc_apis'
require 'helpers/xbmc_config_helper'

module CommandsHelper
  include XbmcConfigHelper
  
  def set_callbacks
    @cmd_callback = url_for :action => :cmd_callback
    @change_vol_cb = url_for :action => :change_vol_callback
    @get_vol_cb = url_for :action => :get_vol_callback
    @mute_callback = url_for :action => :mute_callback
  end
  
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
  
  def clean_video_lib(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::VideoLibrary.clean(callback)
      end
    end
  end
  
  def xbmc_input_up(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Input.up(callback)
      end
    end
  end
  
  def xbmc_input_right(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Input.right(callback)
      end
    end
  end
  
  def xbmc_input_left(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Input.left(callback)
      end
    end
  end
  
  def xbmc_input_down(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Input.down(callback)
      end
    end
  end
  
  def xbmc_input_select(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Input.select(callback)
      end
    end
  end
  
  def xbmc_input_back(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Input.back(callback)
      end
    end
  end
  
  def xbmc_input_home(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Input.home(callback)
      end
    end
  end
end