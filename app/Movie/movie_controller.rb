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
  
  @@conditions = {}
  @@order = :sorttitle
  @@order_dir = 'ASC'
  @@watch_list = false
  
  def initialize
    
  end
  
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
    if @movie
      @movie.destroy_image
      @movie.destroy
    end
    redirect :action => :index  
  end
  
  def update_list
    @movies = filter_movies_xbmc(@@conditions, @@order, @@order_dir)
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
        @movies = filter_movies_xbmc(@@conditions, @@order, @@order_dir)
        unless @movies.blank?
          WebView.execute_js("updateList(#{JSON.generate(@movies)});")
        end
      end
    end
  end
  
  def get_thumb
    set_callbacks
    found_movie = find_movie(@params['movieid'])
    unless found_movie.blank? && found_movie.l_thumb.blank?
      WebView.execute_js("addThumb(#{found_movie.xlib_id},\'#{found_movie.l_thumb}\');")
    end
  end
  
  def load_thumb_cb
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      found_movie = find_movie(@params['movieid'])
      unless found_movie.blank?          
         WebView.execute_js("addThumb(#{found_movie.xlib_id},\'#{found_movie.l_thumb}\');")
      end
    end
  end
  
  def play_movie    
    send_command { Api::V4::Playback.play_movie(url_for(:action => :play_callback),@params['movieid']) }
  end
  
  def play_callback
    puts "BODY FROM PLAY CALLBACK ==== #{@params['body']}"
  end
  
  def open_imdb
    if System.app_installed?("imdb") || System.app_installed?("com.imdb.mobile")
      System.open_url('imdb:///title/' + @params['imdb'])
    else
      System.open_url('http://www.imdb.com/title/' + @params['imdb'])
    end
  end
  
  def load_trailer
    System.open_url('http://www.youtube.com/watch?v=' + @params['youtubeid'])
  end
  
  def options
    @movie = Movie.find(@params['id'])
  end
  
  def watch_later
    @movie = find_movie(@params['movieid'])
    unless @movie.blank?
      puts "Movie === #{@movie}"
      @movie.watch_later = @params['checked']
      puts "Movie WATCH now == #{@movie}"
      @movie.save
    end
  end
  
  def get_watch_list_bool
    @@watch_list
  end
  
  def get_order_dir
    @@order_dir
  end
  
  def sort
    if !@params['watch_later'].blank?
      @@watch_list = @params['watch_later']
      if @@watch_list == "true"
        @@conditions = {:watch_later => @@watch_list}
      else 
        @@conditions = {}
      end
    elsif !@params['order_dir'].blank?
      @@order_dir = "#{@params['order_dir']}"
    end
  end
  
end
