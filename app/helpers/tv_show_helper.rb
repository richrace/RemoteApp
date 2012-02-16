require 'helpers/movie_helper'
require 'helpers/method_helper'
require 'helpers/sort_helper'

module TvShowHelper
  include XbmcConfigHelper
  include MethodHelper
  include SortHelper
  
  def load_tv_shows(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::VideoLibrary.get_tv_shows(callback)
      end
    end
  end
  
  def filter_tvshow_xbmc
    xbmc = XbmcConfigHelper.current_config
    unless xbmc.blank?
      Tvshow.find(:all, :conditions => { :xbmc_id => xbmc.object }, :order => :sorttitle, :orderdir => 'ASC')
    else
      return nil
    end
  end
  
  def find_tvshow(xbmc_lib_id)
    Tvshow.find(:first, :conditions => {:xbmc_id => XbmcConfigHelper.current_config.object, :xlib_id => xbmc_lib_id})
  end
  
  def sync_tv_shows(tv_shows)
    res = handle_new_tvshows(tv_shows)
    update_seasons
    return res
  end
  
  def handle_new_tvshows(xbmc_tvshows)
    list_changed = false
    xbmc_tvshows.each do | new_tvshow |
      found = find_tvshow(new_tvshow[:tvshowid])
      if found.blank?
        n_tvshow = Tvshow.new :xbmc_id => XbmcConfigHelper.current_config.object, :xlib_id => new_tvshow[:tvshowid],  :label => new_tvshow[:label]
        
        n_tvshow.url = url_for(:action => :show, :id => n_tvshow.object)
        
        n_tvshow.thumb = new_tvshow[:thumbnail]
        n_tvshow.fanart = new_tvshow[:fanart]
        n_tvshow.tvdb = new_tvshow[:imdbnumber]
        n_tvshow.plot = new_tvshow[:plot]
        n_tvshow.rating = new_tvshow[:rating]
        n_tvshow.genre = new_tvshow[:genre]
        n_tvshow.year = new_tvshow[:year]
        n_tvshow.playcount = new_tvshow[:playcount]
        n_tvshow.studio = new_tvshow[:studio]
        n_tvshow.title = new_tvshow[:title]
        
        n_tvshow.sorttitle = create_sort_title(n_tvshow.title)
        n_tvshow.save        
        
        list_changed = true
        
        url = XbmcConnect::Files.prepare_download(XbmcConnect::NOCALLB, {:path => n_tvshow.thumb})
        if url['status'] == 'ok'
          unless url['body'].with_indifferent_access[:error]
            xbmc = XbmcConfigHelper.current_config
            unless xbmc.bank?
              file = File.join(Rho::RhoApplication::get_base_app_path(), "#{xbmc.object}.tvshow.#{n_tvshow.xlib_id}.jpg")
              n_tvshow.l_thumb = file
              n_tvshow.save
              
              params = "tvshowid=#{n_tvshow.xlib_id}"
              XbmcConnect.download_file(url['body'].with_indifferent_access[:result][:details][:path], file, url_for(:action => :thumb_callback), params)
            end
          end
        end
      end
    end 
    return list_changed
  end
  
  def update_seasons
    tvshows = filter_tvshow_xbmc
    unless tvshows.blank?
      tvshows.each do | tvshow |
        Api::V4::VideoLibrary.get_seasons(url_for(:controller => :Tvseason, :action => :season_callback),tvshow.xlib_id)
      end
    end
  end
  
end