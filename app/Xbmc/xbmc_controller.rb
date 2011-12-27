require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/ruby_ext'
require 'helpers/browser_helper'
require 'helpers/xbmc/xbmc_connect'
require 'json'

# A simple XBMC JSON RPC API Client. See README for details.
class XbmcController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  
  # Returns an array of available api commands instantiated as Xbmc::Command objects
  def commands
    puts "**** LOADING COMMANDS ****"
    XbmcConnect.load_commands(@params)
  end
  
  def version
    puts "**** LOADING VERSION ****"
    XbmcConnect.load_version(@params)
  end
end
