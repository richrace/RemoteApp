require 'json'
require 'helpers/xbmc_config_helper'
require 'helpers/xbmc/xbmc_connect'
require 'helpers/error_helper'
require 'helpers/xbmc/apis/xbmc_apis'

module Controls
  include XbmcConfigHelper
  include ErrorHelper
  
  # Used to find out what the current player is. Will be needed before using controls
  # This is needed for XBMC Version 10.1
  def play_pause_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == Api::V2::VERSION
        Api::V2::Playback.play_pause(callback)
      elsif (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Playback.play_pause(callback)
      end
    end
  end
  
  def stop_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == ApiV2::VERSION
        Api::V2::Playback.stop(callback)
      elsif (version == ApiV4::VERSION)  || (version == 3)
        Api::V4::Playback.stop(callback)
      end
    end
  end
  
  def rewind_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == ApiV2::VERSION
        Api::V2::Playback.rewind(callback)
      elsif (version == ApiV4::VERSION)  || (version == 3)
        Api::V4::Playback.rewind(callback)
      end
    end
  end
   
  def fast_forward_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == ApiV2::VERSION
        Api::V2::Playback.fast_forward(callback)
      elsif (version == ApiV4::VERSION)  || (version == 3)
        Api::V4::Playback.fast_forward(callback)
      end
    end
  end
  
  def big_skip_forward_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == ApiV2::VERSION
        Api::V2::Playback.big_skip_forward(callback)
      elsif (version == ApiV4::VERSION)  || (version == 3)
        Api::V4::Playback.big_skip_forward(callback)
      end
    end
  end
  
  def sm_skip_forward_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == ApiV2::VERSION
        Api::V2::Playback.sm_skip_forward(callback)
      elsif (version == ApiV4::VERSION)  || (version == 3)
        Api::V4::Playback.sm_skip_forward(callback)    
      end
    end
  end
      
  def big_skip_back_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == ApiV2::VERSION
        Api::V2::Playback.big_skip_back(callback)
      elsif (version == ApiV4::VERSION)  || (version == 3)
        Api::V4::Playback.big_skip_back(callback)
      end
    end
  end
  
  def sm_skip_back_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == ApiV2::VERSION
        Api::V2::Playback.sm_skip_back(callback)
      elsif (version == ApiV4::VERSION)  || (version == 3)
        Api::V4::Playback.sm_skip_back(callback)
      end
    end
  end
  
  def skip_next_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == ApiV2::VERSION
        Api::V2::Playback.skip_next(callback)
      elsif (version == ApiV4::VERSION)  || (version == 3)
        Api::V4::Playback.skip_next(callback)
      end
    end
  end
    
  def skip_prev_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == ApiV2::VERSION
        Api::V2::Playback.skip_previous(callback)
      elsif (version == ApiV4::VERSION)  || (version == 3)
        Api::V4::Playback.skip_previous(callback)
      end
    end
  end
  
end