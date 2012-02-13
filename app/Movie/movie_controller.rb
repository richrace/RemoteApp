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
        @movies = filter_movie_xbmc
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
      end
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
  
  def movie_details_callback
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      @movie_details = @params['body'].with_indifferent_access[:result][:moviedetails]
      found_movie = find_movie(@movie_details[:movieid])
      unless found_movie.blank?
        found_movie.thumb = @movie_details[:thumbnail]
        found_movie.fanart = @movie_details[:fanart]
        found_movie.imdbnumber = @movie_details[:imdbnumber]
        found_movie.trailer = @movie_details[:trailer].scan(/videoid\=+(.+)$/).flatten[0]
        found_movie.plot = @movie_details[:plot]
        found_movie.rating = @movie_details[:rating]
        found_movie.genre = @movie_details[:genre]
        found_movie.year = @movie_details[:year]
        found_movie.playcount = @movie_details[:playcount]
        found_movie.studio = @movie_details[:studio]
        found_movie.title = @movie_details[:title]
        found_movie.save
        
        url = XbmcConnect::Files.prepare_download(XbmcConnect::NOCALLB, {:path => found_movie.thumb})
        if url['status'] == 'ok'
          unless url['body'].with_indifferent_access[:error]
            xbmc = XbmcConfigHelper.current_config
            unless xbmc.bank?
              file = File.join(Rho::RhoApplication::get_base_app_path(), "#{xbmc.object}.movies.#{found_movie.xlib_id}.jpg")
              found_movie.l_thumb = file
              found_movie.save
              params = found_movie.xlib_id
              set_callbacks
              XbmcConnect.download_file(url['body'].with_indifferent_access[:result][:details][:path], file, @load_thumb_cb, params)
            end
          end
        end
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
    if System.app_installed?("imdb")
      System.open_url('imdb:///title/' + @params['imdb'])
    else
      System.open_url('http://www.imdb.com/title/' + @params['imdb'])
    end
  end
  
  def load_trailer
    System.open_url('http://www.youtube.com/watch?v=' + @params['youtubeid'])
  end
end
