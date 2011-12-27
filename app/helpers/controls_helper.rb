require 'json'
require 'helpers/xbmc_config_helper'
require 'helpers/xbmc/xbmc_connect'
require 'helpers/error_helper'
require 'helpers/xbmc/apis/xbmc_apis'

module Controls
  include XbmcConfigHelper
  include ErrorHelper
    
  # Sends a command to the server if the API is loaded if not loads the API.
  # Call example - send_command {XbmcController::JSONRPC.ping (url_for callback)}
  # Can put any callback method in there.
  def self.send_command # yield
    if XbmcConnect.api_loaded?
      yield
    elsif !XbmcConfigHelper.current_config.nil?
      XbmcConnect.load_api(url_for(:action => :control_callback, :query => {:method => "load_api"}))
    end
  end
  
  # Receives a command from the ControlsController to preform. It will check that
  # an API has been loaded before going ahead with the command. If no API has been
  # loaded returns an error to the user.
  def control_player # yield
    if XbmcConnect.api_loaded?
      yield
    else
      ErrorHelper.error_handle
    end
  end
  
  # Used to find out what the current player is. Will be needed before using controls
  # This is needed for XBMC Version 10.1
  def play_pause_player
    callback = url_for :controller => :Controls, :action => :control_callback
    if XbmcConnect.version == Api::V2::VERSION
      Api::V2::Playback.play_pause(callback)
    elsif (XbmcConnect.version == Api::V4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.play_pause(callback)
    end    
  end
  
  def stop_player
    callback = url_for :controller => :Controls, :action => :control_callback
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.stop(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.stop(callback)
    end
  end
  
  def rewind_player
    callback = url_for :controller => :Controls, :action => :control_callback
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.rewind(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.rewind(callback)
    end
  end
   
  def fast_forward_player
    callback = url_for :controller => :Controls, :action => :control_callback
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.fast_forward(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.fast_forward(callback)
    end
  end
  
  def big_skip_forward_player
    callback = url_for :controller => :Controls, :action => :control_callback
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.big_skip_forward(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.big_skip_forward(callback)
    end
  end
  
  def sm_skip_forward_player
    callback = url_for :controller => :Controls, :action => :control_callback
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.sm_skip_forward(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.sm_skip_forward(callback)    
    end
  end
      
  def big_skip_back_player
    callback = url_for :controller => :Controls, :action => :control_callback
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.big_skip_back(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.big_skip_back(callback)
    end
  end
  
  def sm_skip_back_player
    callback = url_for :controller => :Controls, :action => :control_callback
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.sm_skip_back(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.sm_skip_back(callback)
    end
  end
  
  def skip_next_player
    callback = url_for :controller => :Controls, :action => :control_callback
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.skip_next(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.skip_next(callback)
    
    end
  end
    
  def skip_prev_player
    callback = url_for :controller => :Controls, :action => :control_callback
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.skip_previous(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.skip_previous(callback)
    end
  end
  
end