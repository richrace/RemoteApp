# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

# Module to help with the downloading of thumbnails.
module DownloadHelper

  # Main method that is used. Currently only supported by Version 3/4 of JSON RPC API
  # It requires all the parameters. Using the Remote Path it is used to get a downloadable
  # URL address for the thumbnail. It creates the local file where the local path is 
  # specified. It then uses the XbmcConnect.download_file() method to download the file.
  # it appends the filename to the callback parameters (cb_params) 
  def download_thumb(remote_path, local_path, cb_params, callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        sleep(0.05)  
        url = XbmcConnect::Files.prepare_download(XbmcConnect::NOCALLB, {:path => remote_path})
        if url['status'] == 'ok'
          unless url['body'].with_indifferent_access[:error]
            file = File.join(Rho::RhoApplication::get_base_app_path(), local_path)
            cb_params += "&file=#{file}"
            XbmcConnect.download_file(url['body'].with_indifferent_access[:result][:details][:path], file, callback, cb_params)
          end
        end
      end
    end
  end

  # Method to get the Movie THUMBNAIL (not fan art)
  # Sets up the local path, callback and the callback parameters for the given movie.
  # Then calls the download_thumb method to execute the request.
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

  # Method to get the TV Show THUMBNAIL (not fan art)
  # Sets up the local path, callback and the callback parameters for the given TV Show.
  # Then calls the download_thumb method to execute the request.
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

  # Method to get the TV Season THUMBNAIL (not fan art)
  # Sets up the local path, callback and the callback parameters for the given TV Season.
  # Then calls the download_thumb method to execute the request.
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

  # Method to get the TV Episode THUMBNAIL (not fan art)
  # Sets up the local path, callback and the callback parameters for the given TV Episode.
  # Then calls the download_thumb method to execute the request.
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
