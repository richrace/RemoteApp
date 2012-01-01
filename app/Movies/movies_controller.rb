require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/xbmc/apis/xbmc_apis'
require 'helpers/error_helper'


class MoviesController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include ErrorHelper
  
  def index
    @@test = ""
    @callback = url_for :action => :movies_callback
    Api::V4::VideoLibrary.get_movies(@callback)
    render
  end
  
  def movies_callback
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      @@test = @params['body'].with_indifferent_access[:result][:movies]
      render_transition :action => :index 
    end
  end
  
  def get_result
    @@test
  end
  
end