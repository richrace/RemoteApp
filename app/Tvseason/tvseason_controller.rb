require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'helpers/tv_season_helper'
require 'helpers/error_helper'

class TvseasonController < Rho::RhoController
  include BrowserHelper
  include TvSeasonHelper
  include ErrorHelper

  # GET /Tvseason
  def index
    @@tvshowid = @params['tvshowid']
    @tvseasons = find_seasons(@@tvshowid)
    render
  end

  # GET /Tvseason/{1}
  def show
    @tvseason = Tvseason.find(@params['id'])
    if @tvseason
      render :action => :show
    else
      redirect :action => :index
    end
  end

  # GET /Tvseason/new
  def new
    @tvseason = Tvseason.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Tvseason/{1}/edit
  def edit
    @tvseason = Tvseason.find(@params['id'])
    if @tvseason
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Tvseason/create
  def create
    @tvseason = Tvseason.create(@params['tvseason'])
    redirect :action => :index
  end

  # POST /Tvseason/{1}/update
  def update
    @tvseason = Tvseason.find(@params['id'])
    @tvseason.update_attributes(@params['tvseason']) if @tvseason
    redirect :action => :index
  end

  # POST /Tvseason/{1}/delete
  def delete
    @tvseason = Tvseason.find(@params['id'])
    @tvseason.destroy if @tvseason
    redirect :action => :index  
  end
  
  def update_season_list
    @seasons = find_seasons(@@tvshowid)
    unless @seasons.blank?
      WebView.execute_js("updateSeasonList(#{JSON.generate(@seasons)})")
    end
    send_command {Api::V4::VideoLibrary.get_seasons(url_for(:action => :update_season_cb, :query => {:tvshowid => @@tvshowid}),@@tvshowid)}
  end

  def update_season_cb
    if @params['status'] == 'ok'
      if sync_seasons(@params['body'].with_indifferent_access[:result][:seasons], @params['tvshowid'])
        @seasons = find_seasons(@params['tvshowid'])
        unless @seasons.blank?
          WebView.execute_js("updateSeasonList(#{JSON.generate(@seasons)})")
        end
      end
    else
      error_handle(@params)
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    end
  end
  
  def season_callback
    if @params['status'] == 'ok'
      if sync_seasons(@params['body'].with_indifferent_access[:result][:seasons], @params['tvshowid'])
        #@seasons = find_seasons(@params['tvshowid'])
        #unless @seasons.blank?
        #  WebView.execute_js("updateSeasonList(#{JSON.generate(@seasons)})")
        #end
      end
    else
      error_handle(@params)
      #WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    end
  end
  
  def season_thumb_callback
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      season = find_season(@params['tvseasonid'], @params['tvshowid'])
      unless season.blank?
        unless @params['file'].blank?
          season.l_thumb = @params['file']
          season.save
        end
      end
    end
  end
  
  def get_season_thumb
    season = find_season(@params['seasonid'],@params['tvshowid'])
    unless season.blank? 
      unless season.l_thumb.blank?
        WebView.execute_js("addSeasonThumb(#{season.xlib_id}, '#{season.l_thumb}');")
      else
        Thread.new {download_seasonthumb(season)}
      end
    end
  end
end
