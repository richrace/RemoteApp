require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/controls_helper'
require 'helpers/xbmc_config_helper'
require 'xbmc/xbmc_controller'

class ControlsController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include ControlsHelper
  include XbmcConfigHelper
  
  def index
    @@test = "First time"
    if current_config.nil?
        Alert.show_popup ({
          :message => "Please create or activate an XBMC Config",
          :title => "No Active XBMC Config",
          :buttons => ["Close"]
        })
    else
      XbmcController.load_api
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
    if XbmcController.api_loaded?
      yield
      render :action => :wait
    elsif !current_config.nil?
      XbmcController.load_api(url_for(:action => :control_callback, :query => {:method => "load_api"}))
      render :action => :wait
    end
  end
  
  def error_handle(params="")
    @@test = "#{params['http_code']} Error."
    if XbmcController.api_loaded? == false
      Alert.show_popup ({
        :message => XbmcController.error[:msg],
        :title => XbmcController.error[:error],
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
    puts "#{@params['body']}"
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      if @params['method'] == "load_api"
        XbmcController.load_commands(@params)
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
      end
      render_transition :action => :index
    end
  end
  
  # Example method that uses the send_command method. Need to supply :query param to
  # know what command was sent in the the callback function.
  def ping_test 
    send_command {XbmcController::JSONRPC.ping(url_for :action => :control_callback, :query => {:method => "ping"})}
  end
  
  def pause_play
    if XbmcController.api_loaded?
      play_pause_player
    else
      error_handle
    end
  end
  
end