# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'helpers/application_helper'
require 'helpers/xbmc_config_helper'
require 'helpers/xbmc/xbmc_connect'

# Module to help with the handling of Connection Errors throughout the application.
module ErrorHelper 
  include ApplicationHelper

  # Delegates to private methods that sort out the messages.
  # Returns the type of error problem.
  def error_handle(params="")
    type = "unknown"
    if XbmcConfigHelper.current_config.nil?
      # Creates an Alert window notifying users to activate or create 
      # an XBMC Configuration.
      type = error_no_config
    elsif !params.blank?
      # Set Error type and message in XbmcConnect.error
      type = error_http(params)
    elsif !XbmcConnect.api_loaded?
      # Create an Alert windows notifying users that the API hasn't been
      # loaded.
      type = error_no_api
    end
    return type
  end
  
  private 
  # Loads the alert box for having no active XBMC Configuration.
  def error_no_config
    Alert.show_popup ({
      :message => "Please create or activate an XBMC Config",
      :title => "No Active XBMC Config",
      :buttons => ["Close"]
    })
    "no config"
  end
  
  # Checks for the type of HTTP error; either 401 (unauthorised) or 404 (URL/Port incorrect)
  def error_http(params)
    puts "ERROR HANDLE == #{params}"
    type = "http unknown"
    if params['http_error'] == '401'
      XbmcConnect.error = {:error => XbmcConnect::ERROR401, :msg => "Username and Password incorrect"}
      type = "http 401"
    else
      XbmcConnect.error = {:error => XbmcConnect::ERRORURL, :msg => "URL and/or Port incorrect"}
      type = "http 404"
    end
    return type
  end
  
  # Creates the alert box for not loaded the API.
  def error_no_api
    XbmcConnect.error = {:error => XbmcConnect::ERRORAPI, :msg => "API hasn't been loaded. Ensure XBMC Config is correct"}
    Alert.show_popup ({
      :message => "There is no API loaded. Ensure XBMC Config is correct.",
      :title => XbmcConnect::ERRORAPI,
      :buttons => ["Close"]
    })
    "no api"
  end

  

end