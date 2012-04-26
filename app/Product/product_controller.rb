# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/movie_helper'
require 'helpers/xbmc_config_helper'
require 'helpers/product_helper'

# Controller for the Product AKA Buy Later List.
class ProductController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include MovieHelper
  include XbmcConfigHelper
  include ProductHelper

  # Will remove product if it has the exact same name as found in the Movie database.
  # For example, if a Product is named "Grown Ups" and a Movie is named "Grown Ups" 
  # it will be removed.
  # GET /Product
  def index
    products = filter_products_xbmc
    products.each do | product |
      xbmc = XbmcConfigHelper.current_config
      movies = Movie.find(:first, :conditions => {:xbmc_id => xbmc.object, :title => product.title})
      unless movies.blank?
        product.destroy
      end
    end
    @products = filter_products_xbmc
    render
  end

  # GET /Product/{1}
  def show
    @product = Product.find(@params['id'])
    if @product
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Product/new
  def new
    @product = Product.new
    render :action => :new
  end

  # First it checks to see if there is an exact match to the wanted title, if not it checks to make
  # sure that there is a valid Title entry.
  # If there are matches, it will direct the user to either the correct Movie page or a selection of
  # possible Movie matches.
  #
  # POST /Product/create
  def create
    xbmc = XbmcConfigHelper.current_config
    found_movies = Movie.find(:all, :conditions => {:xbmc_id => xbmc.object, :title => @params['product']['title']})
    if found_movies.blank?
      title = @params['product']['title']
      xbmc = XbmcConfigHelper.current_config
      @product = Product.new(:title => title, :xbmc_id => xbmc.object)
      if @product.valid?
        @product.save
        redirect :action => :index
      else 
        @errors = @product.errors.to_json
        render :action => :new
      end
    else
      if found_movies.length == 1
        redirect(:controller => :Movie, :action => :show, :id => found_movies[0].object)
      elsif found_movies.length > 1
        # Create empty string
        params = String.new
        found_movies.each do | movie |
          params << movie.xlib_id.to_s
          params << "_"
        end
        redirect(:controller => :Movie, :action => :found, :query => {:movies => params})
      end
    end
  end

  # POST /Product/{1}/update
  def update
    @product = Product.find(@params['id'])
    @product.update_attributes(@params['product']) if @product
    redirect :action => :index
  end

  # POST /Product/{1}/delete
  def delete
    @product = Product.find(@params['id'])
    @product.destroy if @product
    redirect :action => :index  
  end
end
