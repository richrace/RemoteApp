require 'helpers/movie_helper'
require 'helpers/method_helper'
require 'helpers/tv_episode_helper'

module TvSeasonHelper
  include XbmcConfigHelper
  include MethodHelper
  include TvEpisodeHelper
  
  def find_season(seasonid, tvshowid)
    Tvseason.find(:first, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :tvshow_id => tvshowid, :xlib_id => seasonid})
  end
  
  def find_seasons(tvshowid)
    Tvseason.find(:all, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :tvshow_id => tvshowid})
  end
  
  def sync_seasons(xbmc_seasons, tvshowid)
    unless xbmc_seasons.blank?
      res = handle_new_seasons(xbmc_seasons) || handle_removed_seasons(xbmc_seasons, tvshowid)
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
        
        url = XbmcConnect::Files.prepare_download(XbmcConnect::NOCALLB, {:path => n_season.thumb})
        if url['status'] == 'ok'
          unless url['body'].with_indifferent_access[:error]
            xbmc = XbmcConfigHelper.current_config
            unless xbmc.bank?
              file = File.join(Rho::RhoApplication::get_base_app_path(), "#{xbmc.object}tvshow.#{n_season.tvshow_id}.season.#{n_season.xlib_id}.jpg")
              n_season.l_thumb = file
              n_season.save
              
              params = "tvshowid=#{n_season.xlib_id}&tvseasonid=#{n_season.xlib_id}"
              XbmcConnect.download_file(url['body'].with_indifferent_access[:result][:details][:path], file, url_for(:action => :season_thumb_callback), params)
            end
          end
        end
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
  
end