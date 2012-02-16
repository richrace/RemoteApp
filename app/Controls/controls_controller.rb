require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/controls_helper'
require 'helpers/error_helper'
require 'helpers/method_helper'
require 'helpers/xbmc_config_helper'

class ControlsController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include Controls
  include ErrorHelper
  include MethodHelper
  include XbmcConfigHelper
  
  def index
    @callback = url_for :controller => :Controls, :action => :control_callback
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
    send_command {play_pause_player(@callback)}
  end
  
  def stop
    send_command {stop_player(@callback)}
  end
  
  def rewind
    send_command {rewind_player(@callback)}
  end
  
  def fast_forward
    send_command {fast_forward_player(@callback)}
  end
  
  def big_skip_forward
    send_command {big_skip_forward_player(@callback)}
  end
  
  def sm_skip_forward
    send_command {sm_skip_forward_player(@callback)}
  end
  
  def big_skip_back
    send_command {big_skip_back_player(@callback)}
  end
  
  def sm_skip_back
    send_command {sm_skip_back_player(@callback)}
  end
  
  def skip_next
    send_command {skip_next_player(@callback)}
  end
  
  def skip_prev
    send_command {skip_prev_player(@callback)}
  end

end