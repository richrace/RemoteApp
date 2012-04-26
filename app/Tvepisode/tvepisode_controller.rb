# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'helpers/tv_episode_helper'
require 'helpers/method_helper'
require 'helpers/download_helper'
require 'helpers/error_helper'

# Controller for the TV Episodes.
class TvepisodeController < Rho::RhoController
  include BrowserHelper
  include TvEpisodeHelper
  include MethodHelper
  include DownloadHelper
  include ErrorHelper

  # GET /Tvepisode
  def index
    @@tvshowid = @params['tvshowid']
    @@tvseasonid = @params['tvseasonid']
    render
  end

  # GET /Tvepisode/{1}
  def show
    @tvepisode = Tvepisode.find(@params['id'])
    if @tvepisode
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Tvepisode/{1}/delete
  def delete
    @tvepisode = Tvepisode.find(@params['id'])
    @tvepisode.destroy if @tvepisode
    redirect :action => :index  
  end
  
  # Updates the episode. Updates the display with the database entries first, then requests the list from the XBMC server
  def update_tvepisode_list
    WebView.execute_js("showToastLoading('Loading Episodes');")
    @tvepisodes = find_episodes(@@tvseasonid, @@tvshowid)
    unless @tvepisodes.blank?
      WebView.execute_js("updateEpisodeList(#{JSON.generate(@tvepisodes)});")
    end
    load_tvepisodes(url_for(:action => :update_callback, :query => {:tvshowid => @@tvshowid, :tvseasonid => @@tvseasonid}), @@tvshowid, @@tvseasonid)
  end
  
  # Update tv episode list callback, will sync the episodes and update the display if the list has changed. 
  # If there is a connection error will inform the user.
  def update_callback
    if @params['status'] != 'ok'
      error_handle(@params)
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    else
      if sync_tvepisodes(@params['body'].with_indifferent_access[:result][:episodes], @params['tvshowid'], @params['tvseasonid'])
        @tvepisodes = find_episodes(@@tvseasonid, @@tvshowid)
        unless @tvepisodes.blank?
          WebView.execute_js("updateEpisodeList(#{JSON.generate(@tvepisodes)});")
        end
      end
      WebView.execute_js("hideLoadingToast();")
    end
  end

  # Callback for updating the episodes without updating the display.
  def episodes_callback
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      sync_tvepisodes(@params['body'].with_indifferent_access[:result][:episodes], @params['tvshowid'], @params['tvseasonid'])
    end
  end
  
  # Sends a request to the server to play an episode.
  def play_episode
    unless @params['episodeid'].blank?
      send_command { play_episode_helper(@params['episodeid'], url_for(:action => :play_episode_callback)) }
    end
  end
  
  # Callback for playing an episode, will inform the user of a connection error.
  def play_episode_callback
    if @params['status'] != 'ok'
      error_handle(@params)
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    else
      if @params['body']['result']
        WebView.execute_js("showToastSuccess('Playing Episode');")
        update_playlist
      end
    end
  end

  # Callback for getting Thumbnail. Updates the given episode by the XBMC Library ID, will update the display.
  def episode_thumb_callback
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      found_episode = find_episode(@params['episodeid'])
      unless found_episode.blank?          
        unless @params['file'].blank?
          found_episode.l_thumb = @params['file']
          found_episode.save
          WebView.execute_js("addEpisodeThumb(#{found_episode.xlib_id},\'#{found_episode.l_thumb}\');")
        end
      end
    end
  end

  # Requests the thumbnail to be downloaded.
  def get_episode_thumb
    found_episode = find_episode(@params['episodeid'])
    unless found_episode.blank?
      unless found_episode.l_thumb.blank?
        WebView.execute_js("addEpisodeThumb(#{found_episode.xlib_id},\'#{found_episode.l_thumb}\');")
      else
        download_episodethumb(found_episode)
      end
    end
  end

  # Requests the XBMC Server to add the given episode to the playlist queue.
  def add_episode_to_queue
    if @params['episodeid']
      send_command { queue_episode_helper(@params['episodeid'], url_for(:action => :episode_queue_callback)) }
    end
  end

  # Callback for adding the episode to the playlist. Informations the user of a network error or an error 
  # trying to add the episode to the queue. Will inform the user if it succeed as well.
  def episode_queue_callback
    puts "BODY === #{@params['body']}"
    if @params['status'] != 'ok'
      error_handle(@params)
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    else
      if @params['body']['result'] == 'OK'
        WebView.execute_js("showToastSuccess('Added to the Playlist');")
      else
        WebView.execute_js("showToastError('Can\\\'t add to queue');")
      end
    end
  end

  # Queues all the episodes.
  def play_all_episodes
    add_all_to_playlist
  end

  # Adds all the episodes to the playlist. Will add the episodes to the current playlist
  # Uses synchronous connection to add the episodes. Will inform the user of any error
  # or will let the user know it succeed.
  def queue_all_episodes
    error = false
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if version == Api::V4::VERSION || (version == 3)
        episodes = find_episodes(@@tvseasonid, @@tvshowid)
        episodes.each do | episode | 
          res = Api::V4::Playlist.add_episode(episode.xlib_id)
          puts "QUEUE ALL EPISODES === #{res['body']}"
          if (res['status'] != 'ok') || (res['body']['result'] != 'OK')
            WebView.execute_js("showToastError('Can\\\'t add to queue');")
            error = true
            break
          end
        end
      end
    end
    unless error
      WebView.execute_js("showToastSuccess('Successfully Added');")
    end
  end
  
end
