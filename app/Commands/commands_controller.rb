require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/commands_helper'
require 'helpers/error_helper'
require 'helpers/method_helper'
require 'helpers/xbmc_config_helper'

class CommandsController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include CommandsHelper
  include ErrorHelper
  include MethodHelper
  include XbmcConfigHelper
  
  def index
    @callback = url_for :action => :cmd_callback
    render
  end
  
  def cmd_callback
    if @params['status'] != 'ok'
      error_handle(@params)
    end
  end
  
  def scan_video
    send_command {scan_video_lib(@callback)}
  end
  
  def clean_video
    send_command {clean_video_lib(@callback)}
  end
  
  def input_up
    send_command {xbmc_input_up(@callback)}
  end
  
  def input_left
    send_command {xbmc_input_left(@callback)}
  end
  
  def input_right
    send_command {xbmc_input_right(@callback)}
  end
  
  def input_down
    send_command {xbmc_input_down(@callback)}
  end
  
  def input_select
    send_command {xbmc_input_select(@callback)}
  end
  
  def input_back
    send_command {xbmc_input_back(@callback)}
  end
  
  def input_home
    send_command {xbmc_input_home(@callback)}
  end
end