# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'helpers/movie_helper'
require 'helpers/method_helper'
require 'helpers/tv_episode_helper'
require 'helpers/download_helper'

# Helper for everything to do with TV Seasons.
module TvSeasonHelper
  include XbmcConfigHelper
  include MethodHelper
  include TvEpisodeHelper
  include DownloadHelper
  
  # Finds a single Season based upon a XBMC Library ID for Season and TV Show. 
  # It is filtered by the current active XBMC Configuration
  def find_season(seasonid, tvshowid)
    Tvseason.find(:first, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :tvshow_id => tvshowid, :xlib_id => seasonid})
  end
  
  # Retrieves an array of Seasons for the given TV Show ID. Filtered by the current active XBMC configuration.
  def find_seasons(tvshowid)
    Tvseason.find(:all, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :tvshow_id => tvshowid})
  end
  
  # General method to sync tv seasons. The parameter is the list in the XBMC JSON RPC format.
  # Return either True or False if the list has been updated.
  # If there no seasons, delete all the episodes associated 
  def sync_seasons(xbmc_seasons, tvshowid)
    unless xbmc_seasons.blank?
      res = handle_new_seasons(xbmc_seasons) || handle_removed_seasons(xbmc_seasons, tvshowid)
      update_episodes(tvshowid)
    else
      seasons = find_seasons(tvshowid)
      seasons.each do | season |
        episodes = find_episodes(season.xlib_id, tvshowid)
        episodes.each do | episode |
          episode.destroy_image
          episode.destroy
        end
        season.destroy_image
        season.destroy
      end
      res = true
    end
    return res
  end
  
  # Adds new TV Seasons. found in the XBMC library that aren't in the Remote's library.
  def handle_new_seasons(seasons)
    list_changed = false
    seasons.each do | new_season |
      found = find_season(new_season[:season], new_season[:tvshowid])
      if found.blank?
        n_season = Tvseason.new(
          :xbmc_id => XbmcConfigHelper.current_config.object, 
          :xlib_id => new_season[:season], 
          :tvshow_id => new_season[:tvshowid], 
          :label => new_season[:label], 
          :showtitle => new_season[:showtitle], 
          :thumb => new_season[:thumbnail], 
          :fanart => new_season[:fanart])
        
        n_season.url = "/app/Tvepisode?tvshowid=#{new_season[:tvshowid]}&tvseasonid=#{new_season[:season]}"
        
        n_season.save
        
        list_changed = true
      end
    end
    return list_changed
  end

  # Removes any TV Seasons that are in the Remote's library but not in the XBMC's Library
  # Deletes the episodes if a Season has been removed.
  def handle_removed_seasons(xbmc_tvseasons, tvshowid)
    list_changed = false 
    
    find_seasons(tvshowid).each do | db_season |
      got = false
      xbmc_tvseasons.each do | xb_season |
        if db_season.xlib_id.to_i == xb_season[:season].to_i
          got = true 
          break
        end
      end
      unless got
        episodes = find_episodes(db_season.xlib_id, tvshowid)
        episodes.each do | episode |
          episode.destroy_image
          episode.destroy
        end

        db_season.destroy_image
        db_season.destroy
        list_changed = true
      end
    end
    return list_changed
  end

  # Selects the JSON API from the Current XBMC Configuration
  # Only version 3/4 of JSON API is supported.
  # Updates all the episodes for the TV Show
  def update_episodes(tvshowid)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        seasons = find_seasons(tvshowid)
        unless seasons.blank?
          seasons.each do | season |
            url_cb = url_for(
              :controller => :Tvepisode, 
              :action => :episodes_callback, 
              :query => {
                :tvshowid => season.tvshow_id,
                :tvseasonid => season.xlib_id
              })
            send_command { Api::V4::VideoLibrary.get_episodes(url_cb, season.tvshow_id, season.xlib_id) }
          end
        end
      end
    end
  end

  # Selects the JSON API from the Current XBMC Configuration
  # Only version 3/4 of JSON API is supported.
  # Requests to update the seasons for the given TV Show.
  def update_seasons_helper(callback, tvshowid)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::VideoLibrary.get_seasons(callback, tvshowid)
      end
    end
  end
  
end