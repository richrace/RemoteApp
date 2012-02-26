require 'helpers/movie_helper'
require 'helpers/method_helper'
require 'helpers/tv_episode_helper'
require 'helpers/download_helper'

module TvSeasonHelper
  include XbmcConfigHelper
  include MethodHelper
  include TvEpisodeHelper
  include DownloadHelper
  
  def find_season(seasonid, tvshowid)
    Tvseason.find(:first, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :tvshow_id => tvshowid, :xlib_id => seasonid})
  end
  
  def find_seasons(tvshowid)
    Tvseason.find(:all, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :tvshow_id => tvshowid})
  end
  
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
        
          n_season.url = url_for(:controller => :Tvepisode, :query => {:tvshowid => new_season[:tvshowid], :tvseasonid => new_season[:season]})
        
        n_season.save
        
        list_changed = true
      end
    end
  end

  def handle_removed_seasons(xbmc_tvseasons, tvshowid)
    list_changed = false 
    
    find_seasons(tvshowid).each do | db_season |
      got = false
      xbmc_tvseasons.each do | xb_season |
        if db_season.xlib_id.to_i == xb_season[:xlib_id].to_i
          got = true 
          break
        end
      end
      unless got
        db_season.destroy_image
        db_season.destroy
        list_changed = true
      end
    end
    return list_changed
  end

  def update_episodes(tvshowid)
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