require 'helpers/method_helper'

module TvEpisodeHelper
  include MethodHelper
  
  def find_episodes(seasonid, tvshowid)
    Tvepisode.find(:all, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :tvshow_id => tvshowid, :tvseason_id => seasonid}, :order => :episode, :orderdir => 'ASC')
  end
  
  def find_episode(episodeid)
    Tvepisode.find(:first, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :xlib_id => episodeid})
  end
  
  def load_tvepisodes(callback, tvshowid, tvseasonid)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        send_command {Api::V4::VideoLibrary.get_episodes(callback, tvshowid, tvseasonid)}
      end
    end
  end

  def sync_tvepisodes(xbmc_eps, tvshowid, seasonid)
    unless xbmc_eps.blank?
      db_episodes = find_episodes(seasonid, tvshowid)
      res = handle_new_tvepisodes(xbmc_eps) || handle_removed_tvepisodes(xbmc_eps, db_episodes)
    else
      episodes = find_episodes(seasonid, tvshowid)
      episodes.each do | episode |
        #episode.destroy_image
        episode.destroy
        res = true
      end
    end
    return res
  end
  
  def handle_new_tvepisodes(xbmc_eps)
    list_changed = false
    xbmc_eps.each do | xbmc_ep |
      found = find_episode(xbmc_ep[:episodeid])
      if found.blank?
        n_episode = Tvepisode.new(
          :xbmc_id => XbmcConfigHelper.current_config.object, 
          :xlib_id => xbmc_ep[:episodeid], 
          :episode => xbmc_ep[:episode], 
          :firstaired => xbmc_ep[:firstaired], 
          :title => xbmc_ep[:title], 
          :tvshow_id => xbmc_ep[:tvshowid], 
          :tvseason_id => xbmc_ep[:season], 
          :runtime => xbmc_ep[:runtime], 
          :rating => xbmc_ep[:rating], 
          :plot => xbmc_ep[:plot], 
          :thumb => xbmc_ep[:thumbnail], 
          :fanart => xbmc_ep[:fanart])
        n_episode.save
        
        n_episode.url = url_for(:action => :show, :id => n_episode.object)
        
        n_episode.save
        
        puts "SAVED EPISODE === #{n_episode}"
        
        list_changed = true        
      end
    end
    return list_changed
  end

  def handle_removed_tvepisodes(xbmc_ep, db_episodes)
    list_changed = false 
    
    db_episodes.each do | db_episode |
      got = false
      xbmc_ep.each do | xb_episode |
        if db_episode.xlib_id.to_i == xb_episode[:episodeid].to_i
          got = true 
          break
        end
      end
      unless got
        #db_episode.destroy_image
        db_episode.destroy
        list_changed = true
      end
    end
    return list_changed
  end
  
end