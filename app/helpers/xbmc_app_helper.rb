# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

# Module to help with the Volume Commands.
module XbmcAppHelper
  
  # Selects the correct XBMC version API. Only version 3/4
  # of the JSON RPC API is supported.
  # Toggles mute on the XBMC server's audio.
  def xbmc_toggle_mute(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Application.toggle_mute(callback)
      end
    end
  end

  # Selects the correct XBMC version API. Only version 3/4
  # of the JSON RPC API is supported.
  # Can manually set mute to a Boolean.
  def xbmc_set_mute(callback, bool)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Application.set_mute(callback, bool)
      end
    end
  end
  
  # Selects the correct XBMC version API. Only version 3/4
  # of the JSON RPC API is supported.
  # Sets the Volume to a given amount.
  def xbmc_set_volume(callback, vol)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Application.set_volume(callback, vol.to_i)
      end
    end
  end
  
  # Selects the correct XBMC version API. Only version 3/4
  # of the JSON RPC API is supported.
  # Gets the volume.
  def xbmc_get_volume(callback) 
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Application.get_volume(callback)
      end
    end
  end
  
  # Selects the correct XBMC version API. Only version 3/4
  # of the JSON RPC API is supported.
  # Increases the volume by 5.
  def xbmc_increase_volume(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Application.increase_volume(callback)
      end
    end
  end
  
  # Selects the correct XBMC version API. Only version 3/4
  # of the JSON RPC API is supported.
  # Decreases the volume by 5.
  def xbmc_decrease_volume(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Application.decrease_volume(callback)
      end
    end
  end
  
end