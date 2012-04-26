# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'helpers/movie_helper'
require 'helpers/method_helper'

# Helper for everything to do with the TV Show Controller.
module TvShowHelper
  include XbmcConfigHelper
  include MethodHelper
  
  # Selects the current XBMC Configuration to check version.
  # Currently, only supports JSON RPC version 3/4
  # Loads the TV Shows.
  def load_tv_shows(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::VideoLibrary.get_tv_shows(callback)
      end
    end
  end

  # Filters the TV Shows database by the current active XBMC Configuration.
  # Default amount is set to :all, this means it will return an Array of TV Shows.
  # using :first will only return one object.
  # Conditions could mean any record within the TV Show Model.
  # Order can be viewed in the TvshowController
  # Order_dir is either 'ASC' or 'DSC'
  def filter_tvshows_xbmc(conditions, order, order_dir, amount=:all)
    xbmc = XbmcConfigHelper.current_config
    unless xbmc.blank?
      con = {:xbmc_id => xbmc.object}
      con.merge!(conditions)
      Tvshow.find(amount, :conditions => con, :order => order, :orderdir => order_dir)
    else
      return nil
    end
  end
  
  # Uses filter_tvshows_xbmc to get the default TV Show list. Uses order by sorttitle and 
  # puts the list in ascending order.
  def get_tvshows_xbmc
    filter_tvshows_xbmc({}, :sorttitle, 'ASC')
  end
  
  # Uses filter_tvshows_xbmc, adds an extra condition that the TV Show library ID must be 
  # the one in the parameter. Again, uses sorttitle to order ascending. However, it
  # only returns one entry.
  def find_tvshow(xbmc_lib_id)
    filter_tvshows_xbmc({:xlib_id => xbmc_lib_id}, :sorttitle, 'ASC', :first)
  end
  
  # General method to sync tv shows. The parameter is the list in the XBMC JSON RPC format.
  # Return either True or False if the list has been updated.
  def sync_tv_shows(tv_shows)
    res = handle_new_tvshows(tv_shows) || handle_removed_tvshows(tv_shows)
    return res
  end
  
  # Adds new TV Shows found in the XBMC library that aren't in the Remote's library.
  def handle_new_tvshows(xbmc_tvshows)
    list_changed = false
    xbmc_tvshows.each do | new_tvshow |
      found = find_tvshow(new_tvshow[:tvshowid])
      if found.blank?
        n_tvshow = Tvshow.create(
          :xbmc_id => XbmcConfigHelper.current_config.object, 
          :xlib_id => new_tvshow[:tvshowid],
          :label => new_tvshow[:label],
          :thumb => new_tvshow[:thumbnail],
          :fanart => new_tvshow[:fanart],
          :tvdb => new_tvshow[:imdbnumber],
          :plot => new_tvshow[:plot],
          :rating => new_tvshow[:rating],
          :genre => new_tvshow[:genre],
          :year => new_tvshow[:year],
          :playcount => new_tvshow[:playcount],
          :studio => new_tvshow[:studio],
          :title => new_tvshow[:title])

        n_tvshow.url = "/app/Tvshow/{#{n_tvshow.object}}/show"
        n_tvshow.save        

        # Creates the sort title.
        n_tvshow.create_sort_title
        
        list_changed = true
      end
    end 
    return list_changed
  end

  # Removes any TV Show that are in the Remote's library but not in the XBMC's Library
  def handle_removed_tvshows(xbmc_shows)
    list_changed = false 
    
    get_tvshows_xbmc.each do | db_tvshow |
      got = false
      xbmc_shows.each do | xb_tvshow |
        if db_tvshow.xlib_id.to_i == xb_tvshow[:tvshowid].to_i
          got = true 
          break
        end
      end
      unless got
        # Finds every Season related to the TV Show that has been removed from the XBMC library 
        # and removes those seasons and images.
        tvseasons = Tvseason.find(:all, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :tvshow_id => db_tvshow.xlib_id})
        tvseasons.each do | season |
          season.destroy_image
          season.destroy 
        end
        # Finds every Episode related to the TV Show that has been removed from the XBMC library
        # and removes those episodes and images.
        tvepisodes = Tvepisode.find(:all, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :tvshow_id => db_tvshow.xlib_id})
        tvepisodes.each do | episode |
          episode.destroy_image
          episode.destroy
        end
        # Deletes the TV Show images and the TV Show
        db_tvshow.destroy_image
        db_tvshow.destroy
        list_changed = true
      end
    end
    return list_changed
  end

  # Updates the seasons for each TV Show
  def update_seasons
    tvshows = get_tvshows_xbmc
    unless tvshows.blank?
      tvshows.each do | tvshow |
        send_command {download_seasons(url_for(:controller => :Tvseason, :action => :season_callback, :query => {:tvshowid => tvshow.xlib_id}),tvshow.xlib_id)}
      end
    end
  end

  # Selects the JSON API from the Current XBMC Configuration
  # Only version 3/4 of JSON API is supported.
  # Downloads the seasons for the given tv show
  def download_seasons(callback, tvshowid)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION) || (version == 3)
        Api::V4::VideoLibrary.get_seasons(callback, tvshowid)
      end
    end
  end

end