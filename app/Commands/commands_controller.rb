require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/commands_helper'
require 'helpers/error_helper'
require 'helpers/method_helper'

class CommandsController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include CommandsHelper
  include ErrorHelper
  include MethodHelper
  
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
  
end