require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/ruby_ext'
require 'helpers/browser_helper'
require 'helpers/xbmc/xbmc_connect'
require 'json'
require 'helpers/error_helper'

# A simple XBMC JSON RPC API Client. See README for details.
class XbmcController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include ErrorHelper
  
  # Returns an array of available api commands instantiated as Xbmc::Command objects
  def commands
    puts "**** COMMANDS CALLBACK ****"
    if @params['status'] == 'ok'
      XbmcConnect.load_commands(@params)
    else
      error_handle(@params)
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    end
  end
  
  def version
    puts "**** VERSION CALLBACK ****"
    if @params['status'] == 'ok'
      XbmcConnect.load_version(@params)
    else
      error_handle(@params)
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    end
  end
end
