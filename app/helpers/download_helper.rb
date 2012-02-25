module DownloadHelper

  def download_thumb(remote_path, local_path, cb_params, callback)
    url = XbmcConnect::Files.prepare_download(XbmcConnect::NOCALLB, {:path => remote_path})
    if url['status'] == 'ok'
      unless url['body'].with_indifferent_access[:error]
        file = File.join(Rho::RhoApplication::get_base_app_path(), local_path)
        cb_params += "&file=#{file}"
        XbmcConnect.download_file(url['body'].with_indifferent_access[:result][:details][:path], file, callback, cb_params)
      end
    end
  end

  def download_moviethumb(t_movie)
    xbmc = XbmcConfigHelper.current_config
    unless xbmc.bank?
      remote_path = t_movie.thumb
      local_path = "#{xbmc.object}.movies.#{t_movie.xlib_id}.jpg"
      cb_params = "movieid=#{t_movie.xlib_id}"
      callback = url_for(:controller => :Movie, :action => :load_thumb_cb)
      download_thumb(remote_path, local_path, cb_params, callback)
    end
  end

  def download_tvthumb(n_tvshow)
    xbmc = XbmcConfigHelper.current_config
    unless xbmc.bank?
      remote_path = n_tvshow.thumb
      local_path = "#{xbmc.object}.tvshow.#{n_tvshow.xlib_id}.jpg"
      cb_params = "tvshowid=#{n_tvshow.xlib_id}"
      callback = url_for(:controller => :Tvshow, :action => :thumb_callback)
      download_thumb(remote_path, local_path, cb_params, callback)
    end
  end

  def download_seasonthumb(n_season)
    xbmc = XbmcConfigHelper.current_config
    unless xbmc.bank?
      remote_path = n_season.thumb
      local_path = "#{xbmc.object}.tvshow.#{n_season.tvshow_id}.season.#{n_season.xlib_id}.jpg"
      cb_params = "tvshowid=#{n_season.tvshow_id}&tvseasonid=#{n_season.xlib_id}"
      callback = url_for(:controller => :Tvseason, :action => :season_thumb_callback)
      download_thumb(remote_path, local_path, cb_params, callback)
    end
  end

  def download_episodethumb(n_episode)
    xbmc = XbmcConfigHelper.current_config
    unless xbmc.bank?
      remote_path = n_episode.thumb
      local_path = "#{xbmc.object}.episode.#{n_episode.xlib_id}.jpg"
      cb_params = "episodeid=#{n_episode.xlib_id}"
      callback = url_for(:controller => :Tvepisode, :action => :episode_thumb_callback)
      download_thumb(remote_path, local_path, cb_params, callback)
    end
  end
end
