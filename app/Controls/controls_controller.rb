require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/controls_helper'
require 'helpers/xbmc_config_helper'
require 'helpers/xbmc_connect'

class ControlsController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include ControlsHelper
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
  
  # Sends a command to the server if the API is loaded if not loads the API.
  # Call example - send_command {XbmcController::JSONRPC.ping (url_for callback)}
  # Can put any callback method in there.
  def send_command
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
  
  def error_handle(params="")
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
      elsif @params['method'] == 'get_player'
        @@test = 'Get Player'
        play_pause_player
      elsif @params['method'] == 'play_pause'
        if @params['body'].with_indifferent_access[:result][:paused]
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
    send_command {XbmcConnect::JSONRPC.ping(url_for :action => :control_callback, :query => {:method => "ping"})}
  end
  
  def control_player
    if XbmcConnect.api_loaded?
      yield
    else
      error_handle
    end
  end
  
  def pause_play
    control_player {play_pause_player}
  end
  
  def stop
    control_player {stop_player}
  end
  
  def big_skip_forward
    control_player {big_skip_forward_player}
  end
  
  def sm_skip_forward
    control_player {sm_skip_forward_player}
  end
  
end