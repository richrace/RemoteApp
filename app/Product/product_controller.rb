require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/movie_helper'
require 'helpers/xbmc_config_helper'
require 'helpers/product_helper'

class ProductController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include MovieHelper
  include XbmcConfigHelper
  include ProductHelper

  # GET /Product
  def index
    products = filter_products_xbmc
    products.each do | product |
      movies = search_by_title(product.title)
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

  # POST /Product/create
  def create
    found_movies = search_by_title(@params['product']['title'])
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
