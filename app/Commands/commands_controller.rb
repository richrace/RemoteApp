# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/commands_helper'
require 'helpers/error_helper'
require 'helpers/method_helper'
require 'helpers/xbmc_app_helper'

# Controller for the Commands that can be sent to the XBMC Server.
# These differ from controls as these are inputs to the UI.
# For example, it can move the input or scan libraries.
class CommandsController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include CommandsHelper
  include ErrorHelper
  include MethodHelper
  include XbmcAppHelper
  
  # GET /Commands
  def index
    render
  end
  
  # Only notifies users if there's been a connection error.
  def cmd_callback
    if @params['status'] != 'ok'
      error_handle(@params)
    end
  end
  
  # Requests that the Video Library is scanned
  def scan_video
    set_callbacks
    send_command {scan_video_lib(@cmd_callback)}
  end
  
  # Requests the Video Library is cleaned
  def clean_video
    set_callbacks
    send_command {clean_video_lib(@cmd_callback)}
  end
  
  # Requests to move XBMC selector up
  def input_up
    set_callbacks
    send_command {xbmc_input_up(@cmd_callback)}
  end
  
  # Requests to move XBMC selector left
  def input_left
    set_callbacks
    send_command {xbmc_input_left(@cmd_callback)}
  end
  
  # Requests to move XBMC selector right
  def input_right
    set_callbacks
    send_command {xbmc_input_right(@cmd_callback)}
  end
  
  # Requests to move XBMC selector down
  def input_down
    set_callbacks
    send_command {xbmc_input_down(@cmd_callback)}
  end
  
  # Requests to select what the XBMC selector is on  
  def input_select
    set_callbacks
    send_command {xbmc_input_select(@cmd_callback)}
  end
  
  # Requests for XBMC to use the Back command
  def input_back
    set_callbacks
    send_command {xbmc_input_back(@cmd_callback)}
  end
  
  # Requests for XBMC to use the Home command
  def input_home
    set_callbacks
    send_command {xbmc_input_home(@cmd_callback)}
  end
  
  # Requests for XBMC to toggle the Mute commands
  def toggle_mute
    set_callbacks
    send_command {xbmc_toggle_mute(@mute_callback)}
  end
  
  # Requests XBMC to increase its volume
  def increase_volume
    set_callbacks
    send_command {xbmc_increase_volume(@change_vol_cb)}
  end
  
  # Requests XBMC to decrease its volume
  def decrease_volume
    set_callbacks
    send_command {xbmc_decrease_volume(@change_vol_cb)}
  end
  
  # Gets the current Volume from XBMC.
  def load_volume
    set_callbacks
    send_command {xbmc_get_volume(@get_vol_cb)}
  end
  
  # Updates the volume with the changed amount.
  def change_vol_callback
    if @params['status'] == 'ok'
      cur_vol = @params['body'].with_indifferent_access[:result]
      WebView.execute_js("updateVolume('#{cur_vol}');")
    end
  end
  
  # Updates the volume with the current amount. 
  def get_vol_callback
    if @params['status'] == 'ok'
      cur_vol = @params['body'].with_indifferent_access[:result][:volume]
      WebView.execute_js("updateVolume('#{cur_vol}');")
    end
  end
  
  # Updates the volume with whether or not the mute toggle is active.
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