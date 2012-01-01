require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/xbmc/apis/xbmc_apis'
require 'helpers/error_helper'
require 'helpers/movies_helper'


class MoviesController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include ErrorHelper
  include MoviesHelper
  
  def initialize 
    @movies = Array.new
  end
  
  def index
    set_callbacks
    Api::V4::VideoLibrary.get_movies(@movies_cb)
    render
  end
  
  def movies_callback
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      @params['body'].with_indifferent_access[:result][:movies].each do | movie|
        @movies << movie
      end
      render_transition :action => :index 
    end
  end
  
  def detail_callback
    puts "GETS TO CALLBACK"
    if @params['status'] != 'ok'
      error_handle(@params)
    else
      @movie = @params['body'].with_indifferent_access[:result][:moviedetails]
      render_transition :action => :show 
    end
  end
  
  def movie_detail
    set_callbacks
    puts "AJAX POST TO CONTROLLER\nPARAMS MOVIE ID ===== #{@params['movieid']}\n\n\n"
    Api::V4::VideoLibrary.get_movie_detail(@detail_cb, @params['movieid'])
  end
  
end