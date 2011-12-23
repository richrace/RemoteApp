require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'helpers/xbmc_config_helper'
require 'xbmc/xbmc_controller'

class ControlsController < Rho::RhoController
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
  end
  
  def ping_test 
    if XbmcController.api_loaded?
      XbmcController::JSONRPC.ping(url_for :action => :ping_callback)
      render :action => :wait
    elsif !current_config.nil?
      XbmcController.load_api(url_for :action => :ping_callback)
      render :action => :wait
    end
  end
  
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
      WebView.navigate(url_for :action => :update_screen)  
    else
      @@test = "SUCCESS"
      WebView.navigate(url_for :action => :update_screen)
    end
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
  
end