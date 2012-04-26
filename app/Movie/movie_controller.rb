# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'helpers/movie_helper'
require 'helpers/xbmc/apis/xbmc_apis'
require 'helpers/error_helper'
require 'date'
require 'helpers/method_helper'
require 'helpers/download_helper'

# Controller for the Movies.
class MovieController < Rho::RhoController
  include BrowserHelper
  include MovieHelper
  include XbmcConfigHelper
  include ErrorHelper
  include MethodHelper
  include DownloadHelper
  
  # Conditions needed for sorting the movie list.
  @@conditions = {}
  # Available ordering list
  @@order = {:title => :sorttitle, :recent => :xlib_id, :year => :year, :rating => :rating}
  # Default ordering is sorttitle
  @@active_order = :sorttitle
  # Default ordering direction is ascending.
  @@order_dir = 'ASC'
  # Default to filter the list by if they are in the watch later list is false.
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
  
  # Updates the display with the movies from the database first. Will request the list of the XBMC server.
  def update_list
    WebView.execute_js("showToastLoading('Loading Movies');")
    @movies = filter_movies_xbmc(@@conditions, @@active_order, @@order_dir)
    unless @movies.blank?
      WebView.execute_js("updateList(#{JSON.generate(@movies)});")
    end
    set_callbacks
    send_command {update_movie_list(@movies_cb)}
  end
  
  # Will inform the user if there has been an error. 
  # If not will sync the movies, if there has been changes to the list it will update the display.
  def movies_callback
    if @params['status'] != 'ok'
      error_handle(@params)
        WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    else
      if sync_movies(@params['body'].with_indifferent_access[:result][:movies])
        @movies = filter_movies_xbmc(@@conditions, @@active_order, @@order_dir)
        unless @movies.blank?
          WebView.execute_js("updateList(#{JSON.generate(@movies)});")   
        end
      end
      WebView.execute_js("hideLoadingToast();")
    end
  end
  
  # Requests to download the thumbnail for the give XBMC Library ID. Will update the display
  # if it a thumb is present.
  def get_thumb
    set_callbacks
    found_movie = find_movie(@params['movieid'])
    unless found_movie.blank?
      unless found_movie.l_thumb.blank?
        WebView.execute_js("addThumb(#{found_movie.xlib_id},\'#{found_movie.l_thumb}\');")
      else
        download_moviethumb(found_movie)
      end
    end
  end
  
  # Callback for getting the thumbnail. Will update the display with the given thumbnail, if 
  # there has been a network error, the user is informed.
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
  
  # Requests to play the given Movie base of the XBMC Library ID. 
  def play_movie    
    send_command { play_movie_helper(@params['movieid'], url_for(:action => :play_callback)) }
  end
  
  # Callback for attempting to play a Movie. Will inform the user if it succeeded or not.
  def play_callback
    if @params['status'] != 'ok'
      error_handle(@params)
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    else
      if @params['body']['result']
        WebView.execute_js("showToastSuccess('Playing Movie');")
        update_playlist
      end
    end
  end
  
  # Opens the IMDb page for the given movie either in the IMDb app if it's installed, or will
  # load the IMDb's website in another browser.
  def open_imdb
    if System.app_installed?("imdb") || System.app_installed?("com.imdb.mobile")
      System.open_url('imdb:///title/' + @params['imdb'])
    else
      System.open_url('http://www.imdb.com/title/' + @params['imdb'])
    end
  end
  
  # Opens the YouTube Trailer in an external browser.
  def load_trailer
    System.open_url('http://www.youtube.com/watch?v=' + @params['youtubeid'])
  end
  
  # Loads the options page for the given movie.
  def options
    @movie = Movie.find(@params['id'])
  end
  
  # Toggles the watch later flag. Doing this will either put the movie in the 
  # watch later list or not.
  def watch_later
    @movie = find_movie(@params['movieid'])
    unless @movie.blank?
      @movie.watch_later = @params['checked']
      @movie.save
    end
  end
  
  # Gets if the watch later list is toggled or not.
  def get_watch_list_bool
    @@watch_list
  end
  
  # Gets if current order direction that has been set.
  def get_order_dir
    @@order_dir
  end

  # Gets the list of available ordering.
  def get_order
    @@order
  end

  # Gets the current active order set.
  def get_active_order
    @@active_order
  end
  
  # Sorts the movies list by what the user has selected. 
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

  # Loads the page for the movies that have been found when scanning a barcode.
  def found
    unless @params['movies'].blank?
      @found_movies = Array.new
      ids = @params['movies'].split("_")
      ids.each do | movie_id | 
        @found_movies << find_movie(movie_id.to_i)
      end
    end
  end

  # Adds a given movie to the current playlist.
  def add_to_queue
    if @params['movieid']
      send_command { add_movie_to_queue(@params['movieid'], url_for(:action => :queue_callback)) }
    end
  end

  # Callback for adding a movie to the playlist. Will inform the user of if it has succeeded or not.
  def queue_callback
    puts "BODY === #{@params['body']}"
    if @params['status'] != 'ok'
      error_handle(@params)
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    else
      if @params['body']['result'] == 'OK'
        WebView.execute_js("showToastSuccess('Added Playlist');");
      else
        WebView.execute_js("showToastError('Can\\\'t add to queue');")
      end
    end
  end

end
