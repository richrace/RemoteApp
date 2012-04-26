# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'rho/rhocontroller'
require 'helpers/browser_helper'

# Controller for the More interface. Used to display more options that can be shown in the 
# Tab bar.
class MoreController < Rho::RhoController
  include BrowserHelper
  
  # GET /More
  def index
  end
  
end