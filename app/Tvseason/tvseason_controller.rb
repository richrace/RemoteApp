require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'helpers/tv_season_helper'

class TvseasonController < Rho::RhoController
  include BrowserHelper
  include TvSeasonHelper

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
  
  def updateSeasonList
    @seasons = find_seasons(@@tvshowid)
    unless @seasons.blank?
      WebView.execute_js("updateSeasonList(#{JSON.generate(@seasons)})")
    end
  end
  
  def season_callback
    if @params['status'] == 'ok'
      sync_seasons(@params['body'].with_indifferent_access[:result][:seasons])
    end
  end
  
  def season_thumb_callback
    if @params['status'] != 'ok'
      error_handle(@params)
    end
  end
  
  def updateThumbs
    filter_season_xbmc()
  end
  
  def get_season_thumb
    season = find_season(@params['seasonid'],@params['tvshowid'])
    unless season.blank? && season.l_thumb.blank?
      WebView.execute_js("addSeasonThumb(#{season.xlib_id}, '#{season.l_thumb}');")
    end
  end
end
