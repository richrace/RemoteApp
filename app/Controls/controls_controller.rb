require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/xbmc_config_helper'
require 'xbmc/xbmc_controller'

class ControlsController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
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

  def cancel
    Rho::AsyncHttp.cancel(url_for(:action => :ping_callback) )
    @@test  = 'Request was cancelled.'
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
      XbmcController.load_api(url_for :action => :ping_callback)
      render :action => :wait
    end
  end
  
  # Handles the callback from sending a command. Will show error message if something
  # has gone wrong. Handles what to do with results depending on the Params of the
  # response. 
  def ping_callback 
    puts "#{@params['body']}"
    if @params['status'] != 'ok'
      @@test = "Failed"
      if XbmcController.api_loaded? == false
        Alert.show_popup ({
          :message => XbmcController.error[:msg],
          :title => XbmcController.error[:error],
          :buttons => ["Close"]
        })
      end
      render_transition :action => :index
      #WebView.navigate(url_for :action => :update_screen)  
    else
      if @params['method'] == 'player'
        @@test = @params['body'].with_indifferent_access[:result]
      else
        @@test = @params['method']
      end
      WebView.navigate(url_for :action => :update_screen)
    end
  end
  
  # Example method that uses the send_command method. Need to supply :query param to
  # know what command was sent in the the callback function.
  def ping_test 
    send_command {XbmcController::JSONRPC.ping(url_for :action => :ping_callback, :query => {:method => "ping"})}
  end
  
  # Used to find out what the current player is. Will be needed before using controls
  # This is needed for XBMC Version 10.1
  def get_player
    send_command {XbmcController::Player.get_active_players(url_for :action => :ping_callback, :query => {:method => "player"})}
  end
  
end