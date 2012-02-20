module TvEpisodeHelper
  
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
        Api::V4::VideoLibrary.get_episodes(callback, tvshowid, tvseasonid)
      end
    end
  end
  
  def handle_new_tvepisodes(xbmc_eps)
    puts "IN HANDLE NEW EPISODES === #{xbmc_eps}"
    list_changed = false
    xbmc_eps.each do | xbmc_ep |
      puts "LOOKING AT === #{xbmc_ep}"
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
  
end