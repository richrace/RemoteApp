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
    load_tvepisodes(url_for(:action => :episodes_callback), @@tvshowid, @@tvseasonid)
  end
  
  def episodes_callback
    if @params['status'] != 'ok'
      error_handle(@params)
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    else
      if sync_tvepisodes(@params['body'].with_indifferent_access[:result][:episodes], @@tvshowid, @@tvseasonid)
        @tvepisodes = find_episodes(@@tvseasonid, @@tvshowid)
        unless @tvepisodes.blank?
          WebView.execute_js("updateEpisodeList(#{JSON.generate(@tvepisodes)});")
        end
      end
    end
  end
  
  def play_episode
    puts "EPISODE ID #{@params['episodeid']}"
    unless @params['episodeid'].blank?
      send_command {Api::V4::Playback.play_episode(url_for(:action => :play_episode_callback),@params['episodeid'])}
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
        Thread.new {download_episodethumb(found_episode)}
      end
    end
  end
  
end
