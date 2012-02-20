require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'helpers/tv_episode_helper'
require 'helpers/method_helper'

class TvepisodeController < Rho::RhoController
  include BrowserHelper
  include TvEpisodeHelper
  include MethodHelper

  # GET /Tvepisode
  def index
    @@tvshowid = @params['tvshowid']
    @@tvseasonid = @params['tvseasonid']
   # @tvepisodes = 
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
    send_command {load_tvepisodes(url_for(:action => :episodes_callback), @@tvshowid, @@tvseasonid)}
  end
  
  def episodes_callback
    if handle_new_tvepisodes(@params['body'].with_indifferent_access[:result][:episodes])
      @tvepisodes = find_episodes(@@tvseasonid, @@tvshowid)
      unless @tvepisodes.blank?
        WebView.execute_js("updateEpisodeList(#{JSON.generate(@tvepisodes)});")
      end
    end
  end
end
