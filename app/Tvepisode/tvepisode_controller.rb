require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'helpers/tv_episode_helper'
require 'helpers/method_helper'
require 'helpers/download_helper'
require 'helpers/error_helper'

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

  # GET /Tvepisode/new
  def new
    @tvepisode = Tvepisode.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Tvepisode/{1}/edit
  def edit
    @tvepisode = Tvepisode.find(@params['id'])
    if @tvepisode
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Tvepisode/create
  def create
    @tvepisode = Tvepisode.create(@params['tvepisode'])
    redirect :action => :index
  end

  # POST /Tvepisode/{1}/update
  def update
    @tvepisode = Tvepisode.find(@params['id'])
    @tvepisode.update_attributes(@params['tvepisode']) if @tvepisode
    redirect :action => :index
  end

  # POST /Tvepisode/{1}/delete
  def delete
    @tvepisode = Tvepisode.find(@params['id'])
    @tvepisode.destroy if @tvepisode
    redirect :action => :index  
  end
  
  def update_tvepisode_list
    @tvepisodes = find_episodes(@@tvseasonid, @@tvshowid)
    unless @tvepisodes.blank?
      WebView.execute_js("updateEpisodeList(#{JSON.generate(@tvepisodes)});")
    end
    load_tvepisodes(url_for(:action => :update_callback, :query => {:tvshowid => @@tvshowid, :tvseasonid => @@tvseasonid}), @@tvshowid, @@tvseasonid)
  end
  
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
    end
  end

  def episodes_callback
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      sync_tvepisodes(@params['body'].with_indifferent_access[:result][:episodes], @params['tvshowid'], @params['tvseasonid'])
    end
  end
  
  def play_episode
    unless @params['episodeid'].blank?
      send_command { Api::V4::Playlist.play_episode(@params['episodeid'], url_for(:action => :play_episode_callback)) }
    end
  end
  
  def play_episode_callback
    puts "PLAY/PAUSED"
  end

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

  def add_episode_to_queue
    if @params['episodeid']
      send_command { Api::V4::Playlist.add_episode(@params['episodeid'], url_for(:action => :episode_queue_callback)) }
    end
  end

  def episode_queue_callback
    puts "BODY === #{@params['body']}"
    if @params['status'] != 'ok'
      error_handle(@params)
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    else
      if @params['body']['result'] == 'OK'
        WebView.execute_js("showToastSuccess('Added to the Playlist');");
      else
        WebView.execute_js("showToastError('Can\\\'t add to queue');")
      end
    end
  end

  def play_all_episodes
    Api::V4::Playlist.clear_video
    queue_all_episodes
    Api::V4::Playlist.play_video
  end

  def queue_all_episodes
    error = false
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
    unless error
      WebView.execute_js("showToastSuccess('Successfully Added');")
    end
  end
  
end
