require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/controls_helper'
require 'helpers/xbmc_config_helper'
require 'helpers/xbmc_connect'

class ControlsController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include Controls
  include XbmcConfigHelper
  
  def index
    @@test = "First time"
    unless current_config.nil?
      XbmcConnect.load_api
    end
    render
  end
  
  def update_screen
    render :action => :index
  end
  
  def show_error
    render :action => :error
  end
  
  def get_text
    @@test
  end

  def cancel_control
    Rho::AsyncHttp.cancel
    @@test = 'Request was cancelled.'
    render :action => :index
  end
  
  # Handles the callback from sending a command. Will show error message if something
  # has gone wrong. Handles what to do with results depending on the Params of the
  # response. 
  def control_callback 
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      puts "Body of message:\n#{@params['body']}"
      if @params['method'] == "load_api"
        XbmcConnect.load_commands(@params)
      end  
      if @params['method'] == 'ping'
        @@test = 'Pong!'
      elsif @params['method'] == 'play_pause'
        res = @params['body'].with_indifferent_access[:result]
        paused = false
        if XbmcConnect.version == ApiV2::VERSION
          paused = true if res[:paused]
        elsif (XbmcConnect.version == ApiV4::VERSION) || XbmcConnect.version == 3
          paused = true if res[:speed] == 0
        end
        if paused
          @@test = "Paused"
        else
          @@test = 'Playing'
        end
      elsif @params['method'] == 'stop'
        if @params['body'].with_indifferent_access[:result] == "OK"
          @@test = "Stopped"
        else
          @@test = '???'
        end
      end
      render_transition :action => :index
    end
  end
  
  # Example method that uses the send_command method. Need to supply :query param to
  # know what command was sent in the the callback function.
  def ping_test 
    control_player {ping_test}
  end
  
  def pause_play
    control_player {play_pause_player}
  end
  
  def stop
    control_player {stop_player}
  end
  
  def rewind
    control_player {rewind_player}
  end
  
  def fast_forward
    control_player {fast_forward_player}
  end
  
  def big_skip_forward
    control_player {big_skip_forward_player}
  end
  
  def sm_skip_forward
    control_player {sm_skip_forward_player}
  end
  
  def big_skip_back
    control_player {big_skip_back_player}
  end
  
  def sm_skip_back
    control_player {sm_skip_back_player}
  end
  
  def skip_next
    control_player {skip_next_player}
  end
  
  def skip_prev
    control_player {skip_prev_player}
  end
  
end