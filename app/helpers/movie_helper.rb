require 'helpers/xbmc_config_helper'
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
  
  def filter_movies_xbmc(conditions, order, order_dir, amount=:all)
    xbmc = XbmcConfigHelper.current_config
    unless xbmc.blank?
      con = {:xbmc_id => xbmc.object}
      con.merge!(conditions)
      Movie.find(amount, :conditions => con, :order => order, :orderdir => order_dir)
    else
      return nil
    end
  end
  
  def get_movies_xbmc
    filter_movies_xbmc({}, :sorttitle, 'ASC')
  end
  
  def find_movie(xbmc_lib_id)
    filter_movies_xbmc({:xlib_id => xbmc_lib_id}, :sorttitle, 'ASC', :first)
  end
  
  def sync_movies(movies)
    handle_new_movies(movies) || handle_removed_movies(movies)
  end
  
  def handle_new_movies(xbmc_movies)
    list_changed = false
    xbmc_movies.each do | new_movie |
      found = find_movie(new_movie[:movieid])
      if found.blank?
        t_movie = Movie.create(
          :xbmc_id => XbmcConfigHelper.current_config.object, 
          :xlib_id => new_movie[:movieid],  
          :label => new_movie[:label],
          :thumb => new_movie[:thumbnail],
          :fanart => new_movie[:fanart],
          :imdbnumber => new_movie[:imdbnumber],
          :plot => new_movie[:plot],
          # Strips the YouTube url from the string.
          :trailer => get_youtube_videoid(new_movie[:trailer]),
          :rating => new_movie[:rating],
          :genre => new_movie[:genre],
          :year => new_movie[:year],
          :playcount => new_movie[:playcount],
          :studio => new_movie[:studio],
          :title => new_movie[:title],
          :director => new_movie[:director])
        
        # Makes the url here so can use AJAX call.
        # Manually make the URL instead of using url_for because cannot work
        # in the standalone Module - works fine in Mixin.
        t_movie.url = "/app/Movie/{#{t_movie.object}}/show"
        t_movie.save

        t_movie.create_sort_title
        
        list_changed = true
      end
    end
    return list_changed
  end
  
  def handle_removed_movies(xbmc_movies)
    list_changed = false 
    
    get_movies_xbmc.each do | db_movie |
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

  # This method doesn't search for title by using the databse (SQL). 
  # Instead this gets all the movies in the current XBMC Config and 
  # sees if the given Movie title is in the wanted_title. This is 
  # becuase the wanted_title can include other text such as "DVD" or 
  # "(Comedy)"
  def search_by_title(wanted_title)
    movies = get_movies_xbmc
    found_movies = []
    unless movies.blank? && wanted_title.blank?
      movies.each do | movie |
        if wanted_title.downcase.gsub('-', ' ').include?(movie.title.downcase.gsub('-', ' '))
          found_movies << movie
        end
      end
    end
    return found_movies
  end

  def get_youtube_videoid(xbmc_trailer)
    xbmc_trailer.scan(/videoid\=+(.+)$/).flatten[0]
  end
  
end

