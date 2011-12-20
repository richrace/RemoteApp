require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'helpers/connection_helper'

class ControlsController < Rho::RhoController
  include BrowserHelper
  
  def index
    render :back => '/app'
  end
  
end