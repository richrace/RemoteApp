require 'helpers/movie_helper'
require 'helpers/method_helper'

module TvShowHelper
  include XbmcConfigHelper
  include MethodHelper
  
  def load_tv_shows(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::VideoLibrary.get_tv_shows(callback)
      end
    end
  end

  def filter_tvshows_xbmc(conditions, order, order_dir)
    xbmc = XbmcConfigHelper.current_config
    unless xbmc.blank?
      con = {:xbmc_id => xbmc.object}
      con.merge!(conditions)
      Tvshow.find(:all, :conditions => con, :order => order, :orderdir => order_dir)
    else
      return nil
    end
  end
  
  def get_tvshows_xbmc
    xbmc = XbmcConfigHelper.current_config
    unless xbmc.blank?
      Tvshow.find(:all, :conditions => { :xbmc_id => xbmc.object }, :order => :sorttitle, :orderdir => 'ASC')
    else
      return nil
    end
  end
  
  def find_tvshow(xbmc_lib_id)
    xbmc = XbmcConfigHelper.current_config
    unless xbmc.blank?
      Tvshow.find(:first, :conditions => {:xbmc_id => xbmc.object, :xlib_id => xbmc_lib_id})
    else
      return nil
    end
  end
  
  def sync_tv_shows(tv_shows)
    res = handle_new_tvshows(tv_shows) || handle_removed_tvshows(tv_shows)
    update_seasons
    return res
  end
  
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

        n_tvshow.url = url_for(:action => :show, :id => n_tvshow.object)
        n_tvshow.save        

        n_tvshow.create_sort_title
        
        list_changed = true
      end
    end 
    return list_changed
  end
  
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
        tvseasons = Tvseason.find(:all, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :tvshow_id => db_tvshow.xlib_id})
        tvseasons.each do | season |
          season.destroy_image
          season.destroy 
        end
        tvepisodes = Tvepisode.find(:all, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :tvshow_id => db_tvshow.xlib_id})
        tvepisodes.each do | episode |
          episode.destroy_image
          episode.destroy
        end
        db_tvshow.destroy_image
        db_tvshow.destroy
        list_changed = true
      end
    end
    return list_changed
  end

  def update_seasons
    tvshows = get_tvshows_xbmc
    unless tvshows.blank?
      tvshows.each do | tvshow |
        send_command {Api::V4::VideoLibrary.get_seasons(url_for(:controller => :Tvseason, :action => :season_callback, :query => {:tvshowid => tvshow.xlib_id}),tvshow.xlib_id)}
      end
    end
  end

end