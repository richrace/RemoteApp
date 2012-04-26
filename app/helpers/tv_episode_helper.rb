# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'helpers/method_helper'
require 'helpers/download_helper'
require 'helpers/tv_show_helper'

# Helper for everything to do with TV Episodes
module TvEpisodeHelper
  include MethodHelper
  include DownloadHelper
  include TvShowHelper

  # Retrieves an array of Episodes for the given TV Show ID and Season ID. Filtered by the current active XBMC configuration.
  def find_episodes(seasonid, tvshowid)
    Tvepisode.find(:all, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :tvshow_id => tvshowid, :tvseason_id => seasonid}, :order => :episode, :orderdir => 'ASC')
  end
  
  # Finds a single Episode based upon a XBMC Library ID for TV Episode ID. 
  # It is filtered by the current active XBMC Configuration  
  def find_episode(episodeid)
    Tvepisode.find(:first, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :xlib_id => episodeid})
  end

  # Selects the JSON API from the Current XBMC Configuration
  # Only version 3/4 of JSON API is supported.
  # Loads the Episodes with the given TV Show ID and TV Season ID
  def load_tvepisodes(callback, tvshowid, tvseasonid)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        send_command {Api::V4::VideoLibrary.get_episodes(callback, tvshowid, tvseasonid)}
      end
    end
  end

  # General method to sync tv episode. The parameter is the list in the XBMC JSON RPC format.
  # Return either True or False if the list has been updated.
  # If there no episodes in the list, delete all the episodes associated with the tv show ID and Season ID
  def sync_tvepisodes(xbmc_eps, tvshowid, seasonid)
    unless xbmc_eps.blank?
      res = handle_new_tvepisodes(xbmc_eps) || handle_removed_tvepisodes(xbmc_eps, seasonid, tvshowid)
    else
      episodes = find_episodes(seasonid, tvshowid)
      episodes.each do | episode |
        episode.destroy_image
        episode.destroy
        res = true
      end
    end
    return res
  end
  
  # Adds new TV Episodes. found in the XBMC library that aren't in the Remote's library.
  def handle_new_tvepisodes(xbmc_eps)
    list_changed = false
    xbmc_eps.each do | xbmc_ep |
      found = find_episode(xbmc_ep[:episodeid])
      if found.blank?
        n_episode = Tvepisode.create(
          :xbmc_id => XbmcConfigHelper.current_config.object, 
          :xlib_id => xbmc_ep[:episodeid], 
          :episode => xbmc_ep[:episode], 
          :firstaired => xbmc_ep[:firstaired], 
          :title => xbmc_ep[:title], 
          :tvshow_id => xbmc_ep[:tvshowid], 
          :tvshow_name => find_tvshow(xbmc_ep[:tvshowid]).title,
          :tvseason_id => xbmc_ep[:season], 
          :runtime => xbmc_ep[:runtime], 
          :rating => xbmc_ep[:rating], 
          :plot => xbmc_ep[:plot], 
          :thumb => xbmc_ep[:thumbnail], 
          :fanart => xbmc_ep[:fanart])
        
        n_episode.url = "/app/Tvepisode/{#{n_episode.object}}/show"
        n_episode.save
                
        list_changed = true   
      end
    end
    return list_changed
  end

  # Removes any TV Episode that are in the Remote's library but not in the XBMC's Library
  def handle_removed_tvepisodes(xbmc_ep, seasonid, tvshowid)
    list_changed = false 
    
    find_episodes(seasonid, tvshowid).each do | db_episode |
      got = false
      xbmc_ep.each do | xb_episode |
        if db_episode.xlib_id.to_i == xb_episode[:episodeid].to_i
          got = true 
          break
        end
      end
      unless got
        db_episode.destroy_image
        db_episode.destroy
        list_changed = true
      end
    end
    return list_changed
  end

  # Selects the JSON API from the Current XBMC Configuration
  # Only version 3/4 of JSON API is supported.
  # Plays a given Episode 
  def play_episode_helper(episodeid, callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == Api::V4::VERSION || (version == 3)
        Api::V4::Playlist.play_episode(episodeid, callback)
      end
    end
  end

  # Selects the JSON API from the Current XBMC Configuration
  # Only version 3/4 of JSON API is supported.
  # Add episode to the queue.
  def queue_episode_helper(episodeid, callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == Api::V4::VERSION || (version == 3)
        Api::V4::Playlist.add_episode(episodeid, callback)
      end
    end
  end

  # Selects the JSON API from the Current XBMC Configuration
  # Only version 3/4 of JSON API is supported.
  # Adds all episodes to the playlist. Clears the video playlist
  # first then adds the episodes, then plays the video playlist.
  def add_all_to_playlist
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == Api::V4::VERSION || (version == 3)
        Api::V4::Playlist.clear_video
        queue_all_episodes
        Api::V4::Playlist.play_video
      end
    end
  end
end