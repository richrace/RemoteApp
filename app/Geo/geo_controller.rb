# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/geo_helper'

# Controller for getting the longitude and latitude 
class GeoController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include GeoHelper
  
  # Callback for getting the correct Country Code.
  def geo_callback
    get_country_code
  end
end