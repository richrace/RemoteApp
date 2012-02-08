require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'helpers/movie_helper'
require 'helpers/xbmc/apis/xbmc_apis'
require 'helpers/error_helper'
require 'date'

class MovieController < Rho::RhoController
  include BrowserHelper
  include MovieHelper
  include XbmcConfigHelper
  include ErrorHelper
  
  # GET /Movie
  def index
  end

  # GET /Movie/{1}
  def show
    @movie = Movie.find(@params['id'])
    if @movie
      render :action => :show
    else
      redirect :action => :index
    end
  end

  # GET /Movie/new
  def new
    @movie = Movie.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Movie/{1}/edit
  def edit
    @movie = Movie.find(@params['id'])
    if @movie
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Movie/create
  def create
    @movie = Movie.create(@params['movie'])
    redirect :action => :index
  end

  # POST /Movie/{1}/update
  def update
    @movie = Movie.find(@params['id'])
    @movie.update_attributes(@params['movie']) if @movie
    redirect :action => :index
  end

  # POST /Movie/{1}/delete
  def delete
    @movie = Movie.find(@params['id'])
    @movie.destroy if @movie
    redirect :action => :index  
  end
  
  # Updates the AJAX list. If the API hasn't been loaded will attempt to load
  # the API. Will update list if the API is loaded within the Timeout limit
  # (10 secs). Spawns a new thread to make sure the UI doesn't freeze.
  def update_list
    @movies = filter_movie_xbmc
    unless @movies.blank?
      WebView.execute_js("updateList(#{JSON.generate(@movies)});")
    end
    set_callbacks
    if XbmcConnect.api_loaded?
      Api::V4::VideoLibrary.get_movies(@movies_cb)
    elsif XbmcConfigHelper.current_config.blank?
      error_handle
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
  
  def movies_callback
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      @movies = filter_movie_xbmc
      if @movies.blank? 
        old_len = 0
        @movies = Array.new
      else
        old_len = @movies.size
      end
      @params['body'].with_indifferent_access[:result][:movies].each do | new_movie |
        puts "Dealing with Movie === #{new_movie}"
        found = Movie.find(:all, :conditions => { :xbmc_id => XbmcConfigHelper.current_config.object, :xlib_id => new_movie[:movieid]})
        puts "Have I found this? ==== #{!found.blank?} +++ #{found}"
        if found.blank?
          puts "I'm now dealing with this new movie."
          t_movie = Movie.new :xbmc_id => XbmcConfigHelper.current_config.object, :xlib_id => new_movie[:movieid],  :label => new_movie[:label]
          puts "I've created a new movie; but not saved it yet ==== #{t_movie}"
          t_movie.url = url_for(:action => :show, :id => t_movie.object)
          t_movie.save
          @movies << t_movie
          puts "I've added it to the list! === #{@movies}"
        end
      end
      if old_len != @movies.size
        WebView.execute_js("updateList(#{JSON.generate(@movies)});")
      end
    end
  end
  
end
