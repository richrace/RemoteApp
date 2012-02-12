require 'helpers/movie_helper'
require 'helpers/method_helper'

module MovieHelper
  include XbmcConfigHelper
  include MethodHelper
  
  def set_callbacks
    @movies_cb = url_for(:action => :movies_callback)
    @thumbnail_cb = url_for(:action => :thumb_cb)
    @load_thumb_cb = url_for(:action => :load_thumb_cb) 
    @movie_details_cb = url_for(:action => :movie_details_callback)
  end
  
  def filter_movie_xbmc
    xbmc = XbmcConfigHelper.current_config
    unless xbmc.blank?
      Movie.find(:all, :conditions => { :xbmc_id => xbmc.object }, :order => :sorttitle, :orderdir => 'ASC')
    else
      return nil
    end
  end
  
  def find_movie(xbmc_lib_id)
    Movie.find(:first, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :xlib_id => xbmc_lib_id}) 
  end
  
  def create_sort_title(title)
    title.sub(/^(the|a|an)\s+/i,'')
  end
  
  def sync_movies(movies)
    handle_new_movies(movies) || handle_removed_movies(movies)
  end
  
  def handle_new_movies(xbmc_movies)
    list_changed = false
    xbmc_movies.each do | new_movie |
      found = find_movie(new_movie[:movieid])
      if found.blank?
        t_movie = Movie.new :xbmc_id => XbmcConfigHelper.current_config.object, :xlib_id => new_movie[:movieid],  :label => new_movie[:label]
        t_movie.url = url_for(:action => :show, :id => t_movie.object)
        t_movie.sorttitle = create_sort_title(t_movie.label)
        t_movie.save
        set_callbacks
        send_command {Api::V4::VideoLibrary.get_movie_details(@movie_details_cb, t_movie.xlib_id)}
        list_changed = true
      end
    end
    return list_changed
  end
  
  def handle_removed_movies(xbmc_movies)
    list_changed = false 
    
    filter_movie_xbmc.each do | db_movie |
      got = false
      xbmc_movies.each do | xb_movie |
        if db_movie.xlib_id.to_i == xb_movie[:movieid].to_i
          got = true 
          break
        end
      end
      unless got
        db_movie.destroy_image
        db_movie.destroy
        list_changed = true
      end
    end
    return list_changed
  end
end