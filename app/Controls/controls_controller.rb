require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/controls_helper'
require 'helpers/xbmc_config_helper'
require 'helpers/xbmc/xbmc_connect'
require 'helpers/error_helper'

class ControlsController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include Controls
  include XbmcConfigHelper
  include ErrorHelper
  
  def index
    @callback = url_for :controller => :Controls, :action => :control_callback
    
    unless XbmcConfigHelper.current_config.nil?
      unless XbmcConnect.api_loaded?
        XbmcConnect.load_api
      end
    end
    render
  end
  
  # Handles the callback from sending a command. Will show error message if something
  # has gone wrong. Handles what to do with results depending on the Params of the
  # response. 
  def control_callback 
    if @params['status'] != 'ok'
      error_handle(@params)
    end
  end
    
  def pause_play
    play_pause_player(@callback)
  end
  
  def stop
    stop_player(@callback)
  end
  
  def rewind
    rewind_player(@callback)
  end
  
  def fast_forward
    fast_forward_player(@callback)
  end
  
  def big_skip_forward
    big_skip_forward_player(@callback)
  end
  
  def sm_skip_forward
    sm_skip_forward_player(@callback)
  end
  
  def big_skip_back
    big_skip_back_player(@callback)
  end
  
  def sm_skip_back
    sm_skip_back_player(@callback)
  end
  
  def skip_next
    skip_next_player(@callback)
  end
  
  def skip_prev
    skip_prev_player(@callback)
  end
  
end