require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'helpers/connection_helper'

class XbmcConfigController < Rho::RhoController
  include BrowserHelper

  # GET /XbmcConfig
  def index
    @xbmc_configs = XbmcConfig.find(:all)
    puts "#{@current_xbmc}"
    render :back => '/app'
  end

  # GET /XbmcConfig/{1}
  def show
    @xbmc_config = XbmcConfig.find(@params['id'])
    if @xbmc_config
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /XbmcConfig/new
  def new
    @xbmc_config = XbmcConfig.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /XbmcConfig/{1}/edit
  def edit
    @xbmc_config = XbmcConfig.find(@params['id'])
    if @params['errors']
      @errors = @params['errors']
    end
    if @xbmc_config
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /XbmcConfig/create
  def create
    @xbmc_config = XbmcConfig.new(@params['xbmc_config'])
    
    if @xbmc_config.valid?
      configs = XbmcConfig.find(:all)
      configs.each do |c|
        c.active = false
        c.save
      end
      
      @xbmc_config.active = true
      @xbmc_config.save
      
      con = ConnectionHelper.new(@xbmc_config.url, @xbmc_config.port, @xbmc_config.usrname, @xbmc_config.password)
      con.connect(url_for(:action => :ping_handle), 'JSONRPC.Ping') 
      render :action => :wait     
    else
      @errors = @xbmc_config.errors.to_json
      render :action => :new, :back => url_for(:action => :index)
    end
  end

  # POST /XbmcConfig/{1}/update
  def update
    @xbmc_config = XbmcConfig.find(@params['id'])
    tmp = XbmcConfig.new(@params['xbmc_config'])
    if tmp.valid?
      @xbmc_config.update_attributes(@params['xbmc_config'])
      configs = XbmcConfig.find(:all)
      configs.each do |c|
        c.active = false
        c.save
      end
      @xbmc_config.active = true
      @xbmc_config.save
      con = ConnectionHelper.new(@xbmc_config.url, @xbmc_config.port, @xbmc_config.usrname, @xbmc_config.password)
      con.connect(url_for(:action => :ping_handle), 'JSONRPC.Ping')
      render :action => :wait
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
  
  def ping_handle
    if @params['status'] != 'ok'
      @xbmc_config = XbmcConfig.find(:first, :conditions => {:active => true})
      if @params['http_error'] == '401'
        @errors = {:usrname => "Incorrect", :password => "Incorrect"}.to_json
      else
        @errors = {:url => "Couldn't connect", :port => "Couldn't connect"}.to_json
      end
      WebView.navigate( url_for :action => :edit, :id => @xbmc_config.object, :query => {:errors => @errors})
    elsif @params['body'].with_indifferent_access[:result] == "pong"
        Alert.show_popup "Success!"
        WebView.navigate ( url_for :action => :index )
    end
  end
  
  def cancel_httpcall
    Rho::AsyncHttp.cancel( url_for( :action => :ping_handle) )
    render :action => :index, :back => url_for(:action => :index)
  end
end
