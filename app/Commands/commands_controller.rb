require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/xbmc/apis/xbmc_apis'


class CommandsController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  
  def index
    render
  end
  
  def test_callback
    puts "IT WORKS"
  end
  
  def scan_video
    Api::V4::VideoLibrary.scan(url_for :action => :test_callback)
  end
  
end