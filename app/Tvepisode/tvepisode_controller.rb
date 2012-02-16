require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TvepisodeController < Rho::RhoController
  include BrowserHelper

  # GET /Tvepisode
  def index
    @tvepisodes = Tvepisode.find(:all)
    render :back => '/app'
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
end
