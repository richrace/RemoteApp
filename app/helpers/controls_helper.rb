require 'json'
require 'helpers/xbmc_config_helper'
require 'helpers/xbmc_connect'
require 'helpers/api2'
require 'helpers/api4'

module Controls
  include XbmcConfigHelper
    
  # Sends a command to the server if the API is loaded if not loads the API.
  # Call example - send_command {XbmcController::JSONRPC.ping (url_for callback)}
  # Can put any callback method in there.
  def self.send_command
    if XbmcConnect.api_loaded?
      yield
      #render :action => :wait
    elsif !current_config.nil?
      XbmcConnect.load_api(url_for(:action => :control_callback, :query => {:method => "load_api"}))
      #render :action => :wait
    else
      #render :action => :index
    end
  end
  
  def self.error_handle(params="")
    @@test = "#{params['http_code']} Error."
    if XbmcConnect.api_loaded? == false
      Alert.show_popup ({
        :message => XbmcConnect.error[:msg],
        :title => XbmcConnect.error[:error],
        :buttons => ["Close"]
      })
    end
    if params.empty? || params.blank?
      render :action => :index
    else
      render_transition :action => :index
    end
  end
  
  def control_player
    if XbmcConnect.api_loaded?
      yield
    else
      error_handle
    end
  end
  
  def ping_test
    self.send_command {XbmcConnect::JSONRPC.ping(url_for :action => :control_callback, :query => {:method => "ping"})}
  end
  
  # Used to find out what the current player is. Will be needed before using controls
  # This is needed for XBMC Version 10.1
  def play_pause_player
    if XbmcConnect.version == ApiV2::VERSION
      ApiV2.play_pause (url_for :controller => :Controls, :action => :control_callback, :query => {:method => "play_pause"})
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      ApiV4.play_pause (url_for :controller => :Controls, :action => :control_callback, :query => {:method => "play_pause"})
    else
      @@test = "No API Loaded"
    end    
  end
  
  def stop_player
    if XbmcConnect.version == ApiV2::VERSION
      ApiV2.stop (url_for :controller => :Controls, :action => :control_callback, :query => {:method => "stop"})
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      ApiV4.stop
    else
      @@test = "No API Loaded"
    end
  end
  
  def rewind_player
    if XbmcConnect.version == ApiV2::VERSION
      ApiV2.rewind (url_for :controller => :Controls, :action => :control_callback, :query => {:method => "rewind"})
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      ApiV4.rewind
    else
      @@test = "No API Loaded"
    end
  end
   
  def fast_forward_player
    if XbmcConnect.version == ApiV2::VERSION
      ApiV2.fast_forward (url_for :controller => :Controls, :action => :control_callback, :query => {:method => "fast_forward"})
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      ApiV4.fast_forward
    else
      @@test = "No API Loaded"
    end
  end
  
  def big_skip_forward_player
    if XbmcConnect.version == ApiV2::VERSION
      ApiV2.big_skip_forward (url_for :controller => :Controls, :action => :control_callback, :query => {:method => "big_skip_forward"})
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      ApiV4.big_skip_forward
    else
      @@test = "No API Loaded"
    end
  end
  
  def sm_skip_forward_player
    if XbmcConnect.version == ApiV2::VERSION
      ApiV2.sm_skip_forward (url_for :controller => :Controls, :action => :control_callback, :query => {:method => "sm_skip_forward"})
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      ApiV4.sm_skip_forward
    else
      @@test = "No API Loaded"
    end
  end
      
  def big_skip_back_player
    if XbmcConnect.version == ApiV2::VERSION
      ApiV2.big_skip_back(url_for :controller => :Controls, :action => :control_callback, :query => {:method => "big_skip_back"})
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      ApiV4.big_skip_back
    else
      @@test = "No API Loaded"
    end
  end
  
  def sm_skip_back_player
    if XbmcConnect.version == ApiV2::VERSION
      ApiV2.sm_skip_back(url_for :controller => :Controls, :action => :control_callback, :query => {:method => "sm_skip_back"})
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      ApiV4.sm_skip_back
    else
      @@test = "No API Loaded"
    end
  end
  
  def skip_next_player
    if XbmcConnect.version == ApiV2::VERSION
      ApiV2.skip_next(url_for :controller => :Controls, :action => :control_callback, :query => {:method => "skip_next"})
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      ApiV4.skip_next
    else
      @@test = "No API Loaded"
    end
  end
    
  def skip_prev_player
    if XbmcConnect.version == ApiV2::VERSION
      ApiV2.skip_previous(url_for :controller => :Controls, :action => :control_callback, :query => {:method => "skip_prev"})
    elsif (XbmcConnect.version == ApiV4::VERSION)  || (XbmcConnect.version == 3)
      ApiV4.skip_previous
    else
      @@test = "No API Loaded"
    end
  end
  
end