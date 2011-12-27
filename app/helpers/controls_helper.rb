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
  def self.send_command
    if XbmcConnect.api_loaded?
      yield
      #render :action => :wait
    elsif !XbmcConfigHelper.current_config.nil?
      XbmcConnect.load_api(url_for(:action => :control_callback, :query => {:method => "load_api"}))
      #render :action => :wait
    else
      #render :action => :index
    end
  end
  
  def control_player
    if XbmcConnect.api_loaded?
      yield
    else
      ErrorHelper.error_handle
    end
  end
  
  # Used to find out what the current player is. Will be needed before using controls
  # This is needed for XBMC Version 10.1
  def play_pause_player
    callback = url_for :controller => :Controls, :action => :control_callback, :query => {:method => "play_pause"}
    if XbmcConnect.version == Api::V2::VERSION
      Api::V2::Playback.play_pause(callback)
    elsif (XbmcConnect.version == Api::V4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.play_pause(callback)
    else
      @@test = "No API Loaded"
    end    
  end
  
  def stop_player
    callback = url_for :controller => :Controls, :action => :control_callback, :query => {:method => "stop"}
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.stop(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.stop(callback)
    else
      @@test = "No API Loaded"
    end
  end
  
  def rewind_player
    callback = url_for :controller => :Controls, :action => :control_callback, :query => {:method => "rewind"}
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.rewind(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.rewind(callback)
    else
      @@test = "No API Loaded"
    end
  end
   
  def fast_forward_player
    callback = url_for :controller => :Controls, :action => :control_callback, :query => {:method => "fast_forward"}
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.fast_forward(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.fast_forward(callback)
    else
      @@test = "No API Loaded"
    end
  end
  
  def big_skip_forward_player
    callback = url_for :controller => :Controls, :action => :control_callback, :query => {:method => "big_skip_forward"}
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.big_skip_forward(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.big_skip_forward(callback)
    else
      @@test = "No API Loaded"
    end
  end
  
  def sm_skip_forward_player
    callback = url_for :controller => :Controls, :action => :control_callback, :query => {:method => "sm_skip_forward"}
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.sm_skip_forward(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.sm_skip_forward(callback)
    else
      @@test = "No API Loaded"
    end
  end
      
  def big_skip_back_player
    callback = url_for :controller => :Controls, :action => :control_callback, :query => {:method => "big_skip_back"}
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.big_skip_back(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.big_skip_back(callback)
    else
      @@test = "No API Loaded"
    end
  end
  
  def sm_skip_back_player
    callback = url_for :controller => :Controls, :action => :control_callback, :query => {:method => "sm_skip_back"}
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.sm_skip_back(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.sm_skip_back(callback)
    else
      @@test = "No API Loaded"
    end
  end
  
  def skip_next_player
    callback = url_for :controller => :Controls, :action => :control_callback, :query => {:method => "skip_next"}
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.skip_next(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.skip_next(callback)
    else
      @@test = "No API Loaded"
    end
  end
    
  def skip_prev_player
    callback = url_for :controller => :Controls, :action => :control_callback, :query => {:method => "skip_prev"}
    if XbmcConnect.version == ApiV2::VERSION
      Api::V2::Playback.skip_previous(callback)
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      Api::V4::Playback.skip_previous(callback)
    else
      @@test = "No API Loaded"
    end
  end
  
end