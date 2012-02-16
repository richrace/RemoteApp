require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/commands_helper'
require 'helpers/error_helper'
require 'helpers/method_helper'
require 'helpers/xbmc_config_helper'
require 'helpers/xbmc_app_helper'

class CommandsController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include CommandsHelper
  include ErrorHelper
  include MethodHelper
  include XbmcConfigHelper
  include XbmcAppHelper
  
  def index
    render
  end
  
  def cmd_callback
    if @params['status'] != 'ok'
      error_handle(@params)
    end
  end
  
  def scan_video
    set_callbacks
    send_command {scan_video_lib(@cmd_callback)}
  end
  
  def clean_video
    set_callbacks
    send_command {clean_video_lib(@cmd_callback)}
  end
  
  def input_up
    set_callbacks
    send_command {xbmc_input_up(@cmd_callback)}
  end
  
  def input_left
    set_callbacks
    send_command {xbmc_input_left(@cmd_callback)}
  end
  
  def input_right
    set_callbacks
    send_command {xbmc_input_right(@cmd_callback)}
  end
  
  def input_down
    set_callbacks
    send_command {xbmc_input_down(@cmd_callback)}
  end
  
  def input_select
    set_callbacks
    send_command {xbmc_input_select(@cmd_callback)}
  end
  
  def input_back
    set_callbacks
    send_command {xbmc_input_back(@cmd_callback)}
  end
  
  def input_home
    set_callbacks
    send_command {xbmc_input_home(@cmd_callback)}
  end
  
  def toggle_mute
    set_callbacks
    send_command {xbmc_toggle_mute(@mute_callback)}
  end
  
  def increase_volume
    set_callbacks
    send_command {xbmc_increase_volume(@change_vol_cb)}
  end
  
  def decrease_volume
    set_callbacks
    send_command {xbmc_decrease_volume(@change_vol_cb)}
  end
  
  def load_volume
    set_callbacks
    send_command {xbmc_get_volume(@get_vol_cb)}
  end
  
  def change_vol_callback
    if @params['status'] == 'ok'
      cur_vol = @params['body'].with_indifferent_access[:result]
      WebView.execute_js("updateVolume('#{cur_vol}');")
    end
  end
  
  def get_vol_callback
    if @params['status'] == 'ok'
      cur_vol = @params['body'].with_indifferent_access[:result][:volume]
      WebView.execute_js("updateVolume('#{cur_vol}');")
    end
  end
  
  def mute_callback
    if @params['status'] == 'ok'
      result = @params['body'].with_indifferent_access[:result]
      if result
        cur_vol = "Muted"
        WebView.execute_js("updateVolume('#{cur_vol}');")
      else
        load_volume
      end
    end
  end
end