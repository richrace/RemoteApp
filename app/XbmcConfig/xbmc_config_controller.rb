require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/xbmc_config_helper'
require 'helpers/xbmc/xbmc_connect'
require 'helpers/error_helper'

# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

# Controller Class for the XBMC Configuration
class XbmcConfigController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include XbmcConfigHelper
  include ErrorHelper

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
      @xbmc_config.save
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
  # Removes all associated Movies, TV Shows, TV Seasons, TV Episodes and Products
  def delete
    @xbmc_config = XbmcConfig.find(@params['id'])
    if @xbmc_config
      movies = Movie.find(:all, :conditions => {:xbmc_id => @xbmc_config.object})
      unless movies.blank?
        movies.each do | movie |
          movie.destroy_image
          movie.destroy
        end
      end
      tvshows = Tvshow.find(:all, :conditions => {:xbmc_id => @xbmc_config.object})
      unless tvshows.blank?
        tvshows.each do | tvshow |
          tvshow.destroy_image
          tvshow.destroy
        end
      end
      tvseasons = Tvseason.find(:all, :conditions => {:xbmc_id => @xbmc_config.object})
      unless tvseasons.blank?
        tvseasons.each do | tvseason |
          tvseason.destroy_image
          tvseason.destroy
        end
      end
      tvepisodes = Tvepisode.find(:all, :conditions => {:xbmc_id => @xbmc_config.object})
      unless tvepisodes.blank?
        tvepisodes.each do | tvepisode |
          tvepisode.destroy_image
          tvepisode.destroy
        end
      end
      products = Product.find(:all, :conditions => {:xbmc_id => @xbmc_config.object})
      unless products.blank?
        products.each do | product |
          product.destroy
        end
      end
      @xbmc_config.destroy 
    end
    redirect :action => :index  
  end
  
  # Custom callback for the API. Checks the connection errors, if any to let the user know.
  # If there were any errors, user is directed to the edit page. 
  # If everything went OK the rest of the loading of the API happens, and user is directed
  # to the show page.
  def api_callback
    @xbmc_config = XbmcConfigHelper.current_config
    if @params['status'] != 'ok'
      error_handle(@params)
      if XbmcConnect.error[:error] == XbmcConnect::ERROR401 
        @errors = {:usrname => "Incorrect", :password => "Incorrect"}.to_json
      elsif XbmcConnect.error[:error] == XbmcConnect::ERRORURL
        @errors = {:url => "Couldn't connect", :port => "Couldn't connect"}.to_json
      end
      render_transition :action => :edit
    else
      XbmcConnect.load_version(@params)      
      render_transition :action => :show
    end
  end
  
  # Cancels the current asynchttp call.
  def cancel_httpcall
    Rho::AsyncHttp.cancel
    @xbmc_config = XbmcConfigHelper.current_config
    render :action => :edit
  end
  
  # Deletes the Movie Image Cache.
  def remove_movie_cache
    unless @params['xbmc_id'].blank?
      movies = Movie.find(:all, :conditions => { :xbmc_id => @params['xbmc_id'] } )
      movies.each do | movie |
        movie.destroy_image
      end
      WebView.execute_js("showToastSuccess('Movie images deleted');");
    end
  end

  private 
  
  # Checks to make sure the current XBMC Configuration is active and loads the API.
  # Redirects the user to the wait page.
  def update_xbmc
    configs = XbmcConfig.find(:all)
    configs.each do |c|
      c.active = false
      c.save
    end
    @xbmc_config.active = true
    @xbmc_config.save
    
    # Loads the current current XBMC config. This makes XBMC Connect class
    # to setup the connection information.
    XbmcConfigHelper.current_config
      
    XbmcConnect.load_api url_for(:action => :api_callback)
    render :action => :wait
  end
  
end
