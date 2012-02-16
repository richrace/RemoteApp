module XbmcAppHelper
  
  def xbmc_toggle_mute(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Application.toggle_mute(callback)
      end
    end
  end
  
  def xbmc_set_mute(callback, bool)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Application.set_mute(callback, bool)
      end
    end
  end
  
  def xbmc_set_volume(callback, vol)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Application.set_volume(callback, vol.to_i)
      end
    end
  end
  
  def xbmc_get_volume(callback) 
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Application.get_volume(callback)
      end
    end
  end
  
  def xbmc_increase_volume(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Application.increase_volume(callback)
      end
    end
  end
  
  def xbmc_decrease_volume(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Application.decrease_volume(callback)
      end
    end
  end
  
end