require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/xbmc_config_helper'
require 'helpers/xbmc_connect'

class XbmcConfigController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include XbmcConfigHelper

  # GET /XbmcConfig
  def index
    @xbmc_configs = XbmcConfig.find(:all)
  end

  # GET /XbmcConfig/{1}
  def show
    @xbmc_config = XbmcConfig.find(@params['id'])
    if @xbmc_config
      render :action => :show
    else
      redirect :action => :index
    end
  end

  # GET /XbmcConfig/new
  def new
    @xbmc_config = XbmcConfig.new
    render :action => :new
  end

  # GET /XbmcConfig/{1}/edit
  def edit
    @xbmc_config = XbmcConfig.find(@params['id'])
    if @params['errors']
      @errors = @params['errors']
    end
    if @xbmc_config
      render :action => :edit
    else
      redirect :action => :index
    end
  end

  # POST /XbmcConfig/create
  def create
    @xbmc_config = XbmcConfig.new(@params['xbmc_config'])
    if @xbmc_config.valid?
      update_xbmc
    else
      @errors = @xbmc_config.errors.to_json
      render :action => :new
    end
  end

  # POST /XbmcConfig/{1}/update
  def update
    @xbmc_config = XbmcConfig.find(@params['id'])
    tmp = XbmcConfig.new(@params['xbmc_config'])
    if tmp.valid?
      @xbmc_config.update_attributes(@params['xbmc_config'])
      update_xbmc
    else
      @errors = tmp.errors.to_json
      render :action => :edit
    end      
  end

  # POST /XbmcConfig/{1}/delete
  def delete
    @xbmc_config = XbmcConfig.find(@params['id'])
    @xbmc_config.destroy if @xbmc_config
    redirect :action => :index  
  end
  
  def api_callback
    XbmcConnect.load_commands(@params)
    @xbmc_config = current_config
    if XbmcConnect.api_loaded?
      render_transition :action => :show
    else
      Alert.show_popup ({
        :message => XbmcConnect.error[:msg],
        :title => XbmcConnect.error[:error],
        :buttons => ["Close"]
      })
      if XbmcConnect.error[:error] == XbmcConnect::ERROR401 
        @errors = {:usrname => "Incorrect", :password => "Incorrect"}.to_json
      elsif XbmcConnect.error[:error] == XbmcConnect::ERRORURL
        @errors = {:url => "Couldn't connect", :port => "Couldn't connect"}.to_json
      end
      render_transition :action => :edit 
    end
  end
  
  def cancel_httpcall
    Rho::AsyncHttp.cancel url_for(:action => :api_callback)
    render :action => :index
  end
  
  private 
  
  def update_xbmc
    configs = XbmcConfig.find(:all)
    configs.each do |c|
      c.active = false
      c.save
    end
    @xbmc_config.active = true
    @xbmc_config.save
      
    current_config
      
    XbmcConnect.load_api url_for(:action => :api_callback)
    render :action => :wait
  end
  
end
