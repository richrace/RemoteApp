require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/geo_helper'

class GeoController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include GeoHelper
  
  def geo_callback
    get_country_code
  end
end