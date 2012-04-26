# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'helpers/xbmc_config_helper'
require 'helpers/method_helper'

# Module to helper with everything the Movie Controller does.
module MovieHelper
  include XbmcConfigHelper
  include MethodHelper
  
  # Sets up the callbacks.
  def set_callbacks
    @movies_cb = url_for(:action => :movies_callback)
    @thumbnail_cb = url_for(:action => :thumb_cb)
    @load_thumb_cb = url_for(:action => :load_thumb_cb) 
    @movie_details_cb = url_for(:action => :movie_details_callback)
  end
  
  # Filters the Movies database by the current active XBMC Configuration.
  # Default amount is set to :all, this means it will return an Array of movies.
  # using :first will only return one object.
  # Conditions could mean any record within the Movie Model.
  # Order can be viewed in the MovieController
  # Order_dir is either 'ASC' or 'DSC'
  def filter_movies_xbmc(conditions, order, order_dir, amount=:all)
    xbmc = XbmcConfigHelper.current_config
    unless xbmc.blank?
      con = {:xbmc_id => xbmc.object}
      # Combine the custom conditions with the needed one. If in the conditions parameter
      # :xbmc_id => xbmc.object already exists it doesn't duplicated it.
      con.merge!(conditions)
      Movie.find(amount, :conditions => con, :order => order, :orderdir => order_dir)
    else
      return nil
    end
  end
  
  # Uses filter_movies_xbmc to get the default Movie list. Uses order by sorttitle and 
  # puts the list in ascending order.
  def get_movies_xbmc
    filter_movies_xbmc({}, :sorttitle, 'ASC')
  end
  
  # Uses filter_movies_xbmc, adds an extra condition that the xbmc library ID must be 
  # the one in the parameter. Again, uses sorttitle to order ascending. However, it
  # only returns one entry.
  def find_movie(xbmc_lib_id)
    filter_movies_xbmc({:xlib_id => xbmc_lib_id}, :sorttitle, 'ASC', :first)
  end
  
  # General method to sync movies. The parameter is the list in the XBMC JSON RPC format.
  # Return either True or False if the list has been updated.
  def sync_movies(movies)
    handle_new_movies(movies) || handle_removed_movies(movies)
  end
  
  # Adds new movies found in the XBMC library that aren't in the Remote's library.
  def handle_new_movies(xbmc_movies)
    list_changed = false
    xbmc_movies.each do | new_movie |
      sleep(0.01)
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

        # Create the sort title.
        t_movie.create_sort_title
        
        list_changed = true
      end
    end
    return list_changed
  end
  
  # Removes any movies that are in the Remote's library but not in the XBMC's Library
  def handle_removed_movies(xbmc_movies)
    list_changed = false 
    
    get_movies_xbmc.each do | db_movie |
      sleep(0.01)
      got = false
      xbmc_movies.each do | xb_movie |
        if db_movie.xlib_id.to_i == xb_movie[:movieid].to_i
          got = true 
          break
        end
      end
      unless got
        # Makes sure that the images are removed before destroying the Movie.
        db_movie.destroy_image
        db_movie.destroy
        list_changed = true
      end
    end
    return list_changed
  end

  # This method doesn't search for title by using the database (SQL). 
  # Instead this gets all the movies in the current XBMC Config and 
  # sees if the given Movie title is in the wanted_title. This is 
  # becuase the wanted_title can include other text such as "DVD" or 
  # "(Comedy)"
  # Returns an Array of found Movies.
  def search_by_title(wanted_title)
    movies = get_movies_xbmc
    found_movies = Array.new
    unless movies.blank? && wanted_title.blank?
      movies.each do | movie |
        if wanted_title.downcase.gsub('-', ' ').include?(movie.title.downcase.gsub('-', ' '))
          found_movies << movie
        end
      end
    end
    return found_movies
  end

  # Strips everything but the YouTube Video ID.
  # For example, 'plugin://plugin.video.youtube/?action=play_video&videoid=EEYqgyXyk9A'
  # is the format XBMC gives the YouTube Trailer in. All that is wanted is 'EEYqgyXyk9A'.
  # This uses Regex to remove everything else.
  def get_youtube_videoid(xbmc_trailer)
    xbmc_trailer.scan(/videoid\=+(.+)$/).flatten[0]
  end

  # Selects the correct XBMC version API. Only JSON RPC version 3/4 is supported.
  # Requests to get the XBMC Movies list.
  def update_movie_list(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::VideoLibrary.get_movies(callback)
      end
    end
  end

  # Selects the correct XBMC version API. Only JSON RPC version 3/4 is supported.
  # Requests to play selected list.
  def play_movie_helper(movieid, callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Playlist.play_movie(movieid, callback)
      end
    end
  end

  # Selects the correct XBMC version API. Only JSON RPC version 3/4 is supported.
  # Requests to add the Movie to the XBMC playlist.
  def add_movie_to_queue(movieid, callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Playlist.add_movie(movieid, callback)
      end
    end
  end
  
end

