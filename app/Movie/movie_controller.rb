require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'helpers/movie_helper'
require 'helpers/xbmc/apis/xbmc_apis'
require 'helpers/error_helper'
require 'date'
require 'helpers/method_helper'

class MovieController < Rho::RhoController
  include BrowserHelper
  include MovieHelper
  include XbmcConfigHelper
  include ErrorHelper
  include MethodHelper
  
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
    send_command {Api::V4::VideoLibrary.get_movies(@movies_cb)}
  end
  
  def movies_callback
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      if sync_movies(@params['body'].with_indifferent_access[:result][:movies])
        WebView.execute_js("updateList(#{JSON.generate(filter_movie_xbmc)});")
      end
    end
  end
  
end
