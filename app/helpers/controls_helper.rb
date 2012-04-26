# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'helpers/xbmc_config_helper'
require 'helpers/xbmc/apis/xbmc_apis'

# Helper for the Controls, it selects the correct JSON RPC API
# to be used for the playback controls.
module Controls
  include XbmcConfigHelper
  
  # Selects the correct XBMC version API.
  # Requests XBMC to play/pause anything playing.
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
  
  # Selects the correct XBMC version API.
  # Requests XBMC to stop anything playing.
  def stop_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == Api::V2::VERSION
        Api::V2::Playback.stop(callback)
      elsif (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Playback.stop(callback)
      end
    end
  end
  
  # Selects the correct XBMC version API.
  # Requests XBMC to rewind anything playing.
  def rewind_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == Api::V2::VERSION
        Api::V2::Playback.rewind(callback)
      elsif (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Playback.rewind(callback)
      end
    end
  end
   
  # Selects the correct XBMC version API.
  # Requests XBMC to fast forward anything playing.
  def fast_forward_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == Api::V2::VERSION
        Api::V2::Playback.fast_forward(callback)
      elsif (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Playback.fast_forward(callback)
      end
    end
  end
  
  # Selects the correct XBMC version API.
  # Requests XBMC to take a big skip forward of anything playing.
  def big_skip_forward_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == Api::V2::VERSION
        Api::V2::Playback.big_skip_forward(callback)
      elsif (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Playback.big_skip_forward(callback)
      end
    end
  end
  
  # Selects the correct XBMC version API.
  # Requests XBMC to take a small skip forward of anything playing.
  def sm_skip_forward_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == Api::V2::VERSION
        Api::V2::Playback.sm_skip_forward(callback)
      elsif (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Playback.sm_skip_forward(callback)    
      end
    end
  end
  
  # Selects the correct XBMC version API.
  # Requests XBMC to take a big skip back of anything playing.
  def big_skip_back_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == Api::V2::VERSION
        Api::V2::Playback.big_skip_back(callback)
      elsif (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Playback.big_skip_back(callback)
      end
    end
  end
  
  # Selects the correct XBMC version API.
  # Requests XBMC to take a small skip back for anything playing.
  def sm_skip_back_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == Api::V2::VERSION
        Api::V2::Playback.sm_skip_back(callback)
      elsif (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Playback.sm_skip_back(callback)
      end
    end
  end
  
  # Selects the correct XBMC version API.
  # Requests XBMC to skip to the next item in playlist or chapter.
  def skip_next_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == Api::V2::VERSION
        Api::V2::Playback.skip_next(callback)
      elsif (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Playback.skip_next(callback)
      end
    end
  end
  
  # Selects the correct XBMC version API.
  # Requests XBMC to skip to the previous item in playlist or chapter
  def skip_prev_player(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == Api::V2::VERSION
        Api::V2::Playback.skip_prev(callback)
      elsif (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Playback.skip_prev(callback)
      end
    end
  end
  
end