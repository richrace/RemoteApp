# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/method_helper'
require 'helpers/tv_show_helper'
require 'helpers/error_helper'
require 'helpers/download_helper'

# TV Show Controller Class
class TvshowController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include MethodHelper
  include TvShowHelper
  include ErrorHelper
  include DownloadHelper

  # Used for the sorting of data.
  @@conditions = {}
  # List of the available ordering.
  @@order = {:title => :sorttitle, :year => :year, :rating => :rating}
  # Default ordering.
  @@active_order = :sorttitle
  # Default order direction.
  @@order_dir = 'ASC'

  # GET /Tvshow
  def index
    render
  end

  # Redirects to the Season list for this TV Show if it exists.
  def show
    @tvshow = Tvshow.find(@params['id'])
    if @tvshow
      redirect :controller => :Tvseason, :query => {:tvshowid => @tvshow.xlib_id}
    else
      redirect :action => :index
    end
  end
  
  # Displays the information about the TV Show based on the Param TV Show ID
  def info
    @tvshow = find_tvshow(@params['tvshowid'])
    render
  end
  
  # Loads the TV Shows from the database to display the requests the movies list 
  # from the XBMC server
  def get_tv_shows
    WebView.execute_js("showToastLoading('Loading TV Shows');")
    @tvshows = filter_tvshows_xbmc(@@conditions, @@active_order, @@order_dir)
    unless @tvshows.blank?
      WebView.execute_js("updateTVList(#{JSON.generate(@tvshows)});")
    end
    send_command {load_tv_shows(url_for :action => :tv_shows_callback)}
  end
  
  # Callback method which handles updating the display or telling the user there
  # was a connection problem.
  def tv_shows_callback
    if @params['status'] == 'ok'
      if sync_tv_shows(@params['body'].with_indifferent_access[:result][:tvshows])
        @tvshows = filter_tvshows_xbmc(@@conditions, @@active_order, @@order_dir)
        unless @tvshows.blank?
          WebView.execute_js("updateTVList(#{JSON.generate(@tvshows)});")
        end
      end
      update_seasons
      WebView.execute_js("hideLoadingToast();")
    else
      error_handle(@params)      
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    end
  end
  
  # Gets the thumbnail for the TV Show, needs XBMC TV Show ID as the param
  # If there is already a thumbnail it adds it to the display.
  def get_tv_thumb
    found_tvshow = find_tvshow(@params['tvshowid'])
    unless found_tvshow.blank? 
      unless found_tvshow.l_thumb.blank?
        WebView.execute_js("addTVThumb(#{found_tvshow.xlib_id},\'#{found_tvshow.l_thumb}\');")
      else
        download_tvthumb(found_tvshow)
      end
    end
  end
  
  # Callback for the get thumbnail method, adds the Local reference to the correct TV Show
  # Object. Then updates the display.
  def thumb_callback
    if @params['status'] == 'ok'
      found_tvshow = find_tvshow(@params['tvshowid'])
      unless found_tvshow.blank?
        unless @params['file'].blank?
          found_tvshow.l_thumb = @params['file']
          found_tvshow.save      
          WebView.execute_js("addTVThumb(#{found_tvshow.xlib_id},\'#{found_tvshow.l_thumb}\');")
        end
      end
    else
      error_handle(@params)
    end
  end
  
  # Gets the current set order direction.
  def get_order_dir
    @@order_dir
  end

  # Gets the set of ordering available
  def get_order
    @@order
  end

  # Gets the current active ordering
  def get_active_order
    @@active_order
  end
  
  # Sorts the order of how the user wants the list to be set.
  def tvsort
    if !@params['order_dir'].blank?
      @@order_dir = "#{@params['order_dir']}"
    elsif !@params['order'].blank?
      wanted = @params['order']
      @@order.each do | key, value |
        if wanted == key.to_s
          @@active_order = value 
        end
      end
    end
  end 

end
