require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'


class CommandsController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  
  def index
    render
  end
  
end