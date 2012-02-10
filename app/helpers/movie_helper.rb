require 'helpers/movie_helper'

module MovieHelper
  include XbmcConfigHelper
  
  def set_callbacks
    @movies_cb = url_for(:action => :movies_callback)
    @detail_cb = url_for(:action => :detail_callback)
  end
  
  def filter_movie_xbmc
    xbmc = XbmcConfigHelper.current_config
    if !xbmc.blank?
      Movie.find(:all, :conditions => { :xbmc_id => xbmc.object })
    else
      return nil
    end
  end
  
  def find_movie(xbmc_lib_id)
    Movie.find(:first, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :xlib_id => xbmc_lib_id}) 
  end
  
  def sync_movies(movies)
    handle_new_movies(movies) || handle_removed_movies(movies)
  end
  
  
  def handle_new_movies(xbmc_movies)
    list_changed = false
    xbmc_movies.each do | new_movie |
      puts "Dealing with Movie === #{new_movie}"
      found = find_movie(new_movie[:movieid])
      puts "Have I found this? ==== #{!found.blank?} +++ #{found}"
      if found.blank?
        puts "I'm now dealing with this new movie."
        t_movie = Movie.new :xbmc_id => XbmcConfigHelper.current_config.object, :xlib_id => new_movie[:movieid],  :label => new_movie[:label]
        puts "I've created a new movie; but not saved it yet ==== #{t_movie}"
        t_movie.url = url_for(:action => :show, :id => t_movie.object)
        t_movie.save
        list_changed = true
      end
    end
    return list_changed
  end
  
  def handle_removed_movies(xbmc_movies)
    list_changed = false 
    
    filter_movie_xbmc.each do | db_movie |
      got = false
      puts "Database Movie ----- #{db_movie}"
      xbmc_movies.each do | xb_movie |
        puts "XBMC Movie ---- #{xb_movie}"
        puts "Comparing DB --- #{db_movie.xlib_id.to_i} to XB --- #{xb_movie[:movieid].to_i}"
        if db_movie.xlib_id.to_i == xb_movie[:movieid].to_i
          puts "Movie found!"
          got = true 
          break
        end
      end
      unless got
        puts "Haven't got a match; deleting ---- #{db_movie}"
        db_movie.destroy
        list_changed = true
      end
    end
    return list_changed
  end

end