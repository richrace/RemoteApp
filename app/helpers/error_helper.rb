require 'helpers/application_helper'
require 'helpers/xbmc_config_helper'

module ErrorHelper
  include ApplicationHelper
  include XbmcConfigHelper
    
  def error_handle(params="")
    type = "unknown"
    if XbmcConfigHelper.current_config.nil?
      type = error_no_config
    elsif !params.blank?
      type = error_http(params)
    elsif !XbmcConnect.api_loaded?
      type = error_no_api
    end
    return type
  end
  
  private 
  def error_no_config
    Alert.show_popup ({
      :message => "Please create or activate an XBMC Config",
      :title => "No Active XBMC Config",
      :buttons => ["Close"]
    })
    "no config"
  end
  
  def error_http(params)
    type = "http unknown"
    if params['http_error'] == '401'
      XbmcConnect.error = {:error => XbmcConnect::ERROR401, :msg => "Couldn't connect. Username and Password incorrect"}
      XbmcConnect.api_loaded = false
      XbmcConnect.version = 0
      type = "http 401"
    else
      XbmcConnect.error = {:error => XbmcConnect::ERRORURL, :msg => "Couldn't connect.  URL and/or Port incorrect"}
      XbmcConnect.api_loaded = false
      XbmcConnect.version = 0
      type = "http 404"
    end
    Alert.show_popup ({
      :message => XbmcConnect.error[:msg],
      :title => XbmcConnect.error[:error],
      :buttons => ["Close"]
    })
    return type
  end
  
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