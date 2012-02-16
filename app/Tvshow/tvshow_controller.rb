require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/method_helper'
require 'helpers/tv_show_helper'
require 'helpers/error_helper'

class TvshowController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include MethodHelper
  include TvShowHelper
  include ErrorHelper

  # GET /Tvshow
  def index
    render
  end

  # GET /Tvshow/{1}
  def show
    @tvshow = Tvshow.find(@params['id'])
    if @tvshow
      redirect :controller => :Tvseason, :query => {:tvshowid => @tvshow.xlib_id}
    else
      redirect :action => :index
    end
  end
  
  def get_tv_shows
    @tvshows = filter_tvshow_xbmc
    unless @tvshows.blank?
      WebView.execute_js("updateTVList(#{JSON.generate(@tvshows)});")
    end
    send_command {load_tv_shows(url_for :action => :tv_shows_callback)}
  end
  
  def tv_shows_callback
    if @params['status'] == 'ok'
      if sync_tv_shows(@params['body'].with_indifferent_access[:result][:tvshows])
        @tvshows = filter_tvshow_xbmc
        unless @tvshows.blank?
          WebView.execute_js("updateTVList(#{JSON.generate(@tvshows)});")
        end
      end
    end
  end
  
  def get_tv_thumb
    found_tvshow = find_tvshow(@params['tvshowid'])
    unless found_tvshow.blank? && found_tvshow.l_thumb.blank?
      sleep(0.2)
        WebView.execute_js("addTVThumb(#{found_tvshow.xlib_id},\'#{found_tvshow.l_thumb}\');")
    end
  end
  
  def thumb_callback
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      found_tvshow = find_tvshow(@params['tvshowid'])
      unless found_tvshow.blank?
        WebView.execute_js("addTVThumb(#{found_tvshow.xlib_id},\'#{found_tvshow.l_thumb}\');")
      end
    end
  end
end
