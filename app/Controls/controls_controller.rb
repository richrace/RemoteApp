# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/controls_helper'
require 'helpers/error_helper'
require 'helpers/method_helper'
require 'helpers/xbmc_config_helper'

# Controller for the Controls class. This differs to the Commands class
# as this is for controlling the playback of the XBMC server.
class ControlsController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include Controls
  include ErrorHelper
  include MethodHelper
  include XbmcConfigHelper
  
  # GET /Controls
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
  
  # Requests the current playing media pauses/plays
  def pause_play
    send_command {play_pause_player(@callback)}
  end
  
  # Requests the current playing media stops
  def stop
    send_command {stop_player(@callback)}
  end
  
  # Requests the current playing media rewinds
  def rewind
    send_command {rewind_player(@callback)}
  end
  
  # Requests the current playing media fast forwards
  def fast_forward
    send_command {fast_forward_player(@callback)}
  end
  
  # Requests the current playing media does a big skip forward
  def big_skip_forward
    send_command {big_skip_forward_player(@callback)}
  end
  
  # Requests the current playing media does a small skip forward
  def sm_skip_forward
    send_command {sm_skip_forward_player(@callback)}
  end
  
  # Requests the current playing media does a big skip backward
  def big_skip_back
    send_command {big_skip_back_player(@callback)}
  end
  
  # Requests the current playing media does a small skip backward
  def sm_skip_back
    send_command {sm_skip_back_player(@callback)}
  end
  
  # Requests the current playing media skips next, either chapter or playlist item.
  def skip_next
    send_command {skip_next_player(@callback)}
  end
  
  # Requests the current playing media skips previous, either chapter or playlist item.
  def skip_prev
    send_command {skip_prev_player(@callback)}
  end

end