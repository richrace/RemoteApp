require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'helpers/movie_helper'
require 'helpers/xbmc/apis/xbmc_apis'
require 'helpers/error_helper'
require 'date'
require 'helpers/method_helper'
require 'helpers/download_helper'

class MovieController < Rho::RhoController
  include BrowserHelper
  include MovieHelper
  include XbmcConfigHelper
  include ErrorHelper
  include MethodHelper
  include DownloadHelper
  
  @@conditions = {}
  @@order = {:title => :sorttitle, :recent => :xlib_id, :year => :year, :rating => :rating}
  @@active_order = :sorttitle
  @@order_dir = 'ASC'
  @@watch_list = false 

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
    WebView.execute_js("showLoading('Loading Movies');")
    @movies = filter_movies_xbmc(@@conditions, @@active_order, @@order_dir)
    unless @movies.blank?
      ensure_sorted(@movies)
      WebView.execute_js("updateList(#{JSON.generate(@movies)});")
      # Needed here because if there isn't an update the loading message stays.
      WebView.execute_js("hideLoading();")
    end
    set_callbacks
    send_command {Api::V4::VideoLibrary.get_movies(@movies_cb)}
  end
  
  def movies_callback
    if @params['status'] != 'ok'
      error_handle(@params)
      WebView.execute_js("hideLoading();")
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")      
    else
      if sync_movies(@params['body'].with_indifferent_access[:result][:movies])
        @movies = filter_movies_xbmc(@@conditions, @@active_order, @@order_dir)
        ensure_sorted(@movies)
        unless @movies.blank?
          WebView.execute_js("updateList(#{JSON.generate(@movies)});")        
        end
      end
    end
  end
  
  def get_thumb
    set_callbacks
    found_movie = find_movie(@params['movieid'])
    unless found_movie.blank?
      unless found_movie.l_thumb.blank?
        WebView.execute_js("addThumb(#{found_movie.xlib_id},\'#{found_movie.l_thumb}\');")
      else
        Thread.new {download_moviethumb(found_movie)}
      end
    end
  end
  
  def load_thumb_cb
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      found_movie = find_movie(@params['movieid'])
      unless found_movie.blank?          
        unless @params['file'].blank?
          found_movie.l_thumb = @params['file']
          found_movie.save
          WebView.execute_js("addThumb(#{found_movie.xlib_id},\'#{found_movie.l_thumb}\');")
        end
      end
    end
  end
  
  def play_movie    
    send_command { Api::V4::Playlist.play_movie(@params['movieid'], url_for(:action => :play_callback)) }
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

  def get_order
    @@order
  end

  def get_active_order
    @@active_order
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
    elsif !@params['order'].blank?
      wanted = @params['order']
      @@order.each do | key, value |
        if wanted == key.to_s
          @@active_order = value 
        end
      end
    end
  end 

  # Ensure that the list has been sorted properly.
  # This is used because Rhom only seems to sort by the first 
  # number. Therefore, iterate over the list to make sure it has
  # been sorted. This works for both ASC and DESC lists.
  def ensure_sorted(movies)
    if @@active_order == @@order[:recent]
      movies.sort_by! {|movie| movie.xlib_id.to_i}
      if @@order_dir == 'DESC'
        movies.reverse!
      end
    elsif @@active_order == @@order[:rating]
      movies.sort_by! {|movie| movie.rating.to_f}
      if @@order_dir == 'DESC'
        movies.reverse!
      end
    end
  end

  def found
    unless @params['movies'].blank?
      puts "MOVIES === #{@params['movies']}"
    end
  end

end
