require 'helpers/application_helper'
require 'helpers/xbmc_config_helper'

module ErrorHelper
  include ApplicationHelper
  include XbmcConfigHelper
    
  def error_handle(params="")
    if XbmcConfigHelper.current_config.nil?
      Alert.show_popup ({
        :message => "Please create or activate an XBMC Config",
        :title => "No Active XBMC Config",
        :buttons => ["Close"]
      })
    elsif !params.blank?
      if params['http_code'] == '401'
        XbmcConnect.error = {:error => XbmcConnect::ERROR401, :msg => "Couldn't connect. Username and Password incorrect"}
        XbmcConnect.api_loaded = false
        XbmcConnect.version = 0
      else
        XbmcConnect.error = {:error => XbmcConnect::ERRORURL, :msg => "Couldn't connect.  URL and/or Port incorrect"}
        XbmcConnect.api_loaded = false
        XbmcConnect.version = 0
      end
      Alert.show_popup ({
        :message => XbmcConnect.error[:msg],
        :title => XbmcConnect.error[:error],
        :buttons => ["Close"]
      })
    else
      unless XbmcConnect.api_loaded?
        Alert.show_popup ({
          :message => "There is no API loaded. Ensure XBMC Config is correct.",
          :title => XbmcConnect::ERRORAPI,
          :buttons => ["Close"]
        })
      end
    end
  end

end