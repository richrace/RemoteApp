require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/xbmc/apis/xbmc_apis'
require 'helpers/error_helper'
require 'helpers/movies_helper'
require 'date'


class MoviesController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include ErrorHelper
  include MoviesHelper
  
  def initialize 
    @movies = Array.new
  end
  
  def index
    update_list
  end
  
  def thumbcb
    WebView.execute_js("addFile(\'#{@@file}\');")
  end
  
  def movies_callback
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      @params['body'].with_indifferent_access[:result][:movies].each do | movie|
        @movies << movie
      end
      #render_transition :action => :index 
      WebView.execute_js("updateList(#{JSON.generate(@movies)});")
    end
  end
  
  def detail_callback
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      @movie = @params['body'].with_indifferent_access[:result][:moviedetails]
      
      url = XbmcConnect::Files.prepare_download(XbmcConnect::NOCALLB, {:path => @movie['thumbnail']})
      
      if url['status'] == 'ok'
        puts url['body']
        @@file = File.join(Rho::RhoApplication::get_base_app_path(), "#{@movie['movieid']}.jpg")
        XbmcConnect.download_file(url['body'].with_indifferent_access[:result][:details][:path], @@file, url_for(:action => :thumbcb))
      
      end
      render_transition :action => :show
    end
  end
  
  def movie_detail
    set_callbacks
    Api::V4::VideoLibrary.get_movie_detail(@detail_cb, @params['movieid'])
  end
  
  # Updates the AJAX list. If the API hasn't been loaded will attempt to load
  # the API. Will update list if the API is loaded within the Timeout limit
  # (10 secs). Spawns a new thread to make sure the UI doesn't freeze.
  def update_list
    set_callbacks
    if XbmcConnect.api_loaded?
      Api::V4::VideoLibrary.get_movies(@movies_cb)
    else
      XbmcConnect.load_api
      Thread.new {
        start = Time.now
        timeout = 10
        cur_wait = 0
        while (cur_wait <= timeout)
          now = Time.now
          cur_wait = now - start
          sleep(1)
          break if XbmcConnect.api_loaded?
        end
        if XbmcConnect.api_loaded?
          Api::V4::VideoLibrary.get_movies(@movies_cb)
        end
      }
    end
  end
  
end