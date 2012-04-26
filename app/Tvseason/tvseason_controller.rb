# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'helpers/tv_season_helper'
require 'helpers/error_helper'

# TV Season Controller used for the REST interface.
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

  # POST /Tvseason/{1}/delete
  def delete
    @tvseason = Tvseason.find(@params['id'])
    @tvseason.destroy if @tvseason
    redirect :action => :index  
  end
  
  # Updates the Seasons for the given TV Show ID. Will update the display with what's in the database first
  def update_season_list
    WebView.execute_js("showToastLoading('Loading Seasons');")
    @seasons = find_seasons(@@tvshowid)
    unless @seasons.blank?
      WebView.execute_js("updateSeasonList(#{JSON.generate(@seasons)})")
    end
    send_command { update_seasons_helper(url_for(:action => :update_season_cb, :query => {:tvshowid => @@tvshowid}),@@tvshowid) }
  end

  # Callback for the update season list. Will sync the seasons and display the updated list. 
  # If there is a connection error the user will be notified.
  def update_season_cb
    if @params['status'] == 'ok'
      if sync_seasons(@params['body'].with_indifferent_access[:result][:seasons], @params['tvshowid'])
        @seasons = find_seasons(@params['tvshowid'])
        unless @seasons.blank?
          WebView.execute_js("updateSeasonList(#{JSON.generate(@seasons)})")
        end
      end
      WebView.execute_js("hideLoadingToast();")
    else
      error_handle(@params)
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    end
  end
  
  # Updates the seasons, but does not update the display.
  def season_callback
    if @params['status'] == 'ok'
      sync_seasons(@params['body'].with_indifferent_access[:result][:seasons], @params['tvshowid'])
    else
      error_handle(@params)
    end
  end
  
  # Callback for get season thumb, will add the returned image to the given season by the season ID and TV Show ID.
  # Updates the display with the image.
  def season_thumb_callback
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      season = find_season(@params['tvseasonid'], @params['tvshowid'])
      unless season.blank?
        unless @params['file'].blank?
          season.l_thumb = @params['file']
          season.save
          WebView.execute_js("addSeasonThumb(#{season.xlib_id}, '#{season.l_thumb}');")
        end
      end
    end
  end
  
  # Gets the season thumb, downloads the season thumbnail based on the given season ID and TV Show ID
  def get_season_thumb
    season = find_season(@params['seasonid'],@params['tvshowid'])
    unless season.blank? 
      unless season.l_thumb.blank?
        WebView.execute_js("addSeasonThumb(#{season.xlib_id}, '#{season.l_thumb}');")
      else
        download_seasonthumb(season)
      end
    end
  end
end
