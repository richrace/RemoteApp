require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/geo_helper'
require 'helpers/product_helper'
require 'helpers/movie_helper'

class BarcodeScanController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include GeoHelper
  include ProductHelper
  include MovieHelper
  
  def index
    @@country_code = "US"
    render
  end
  
  def load_geo
    get_geo
    #######
    # Need to test on device but System.get_property('country') may get
    # they country code. However, this does not allow options to buy
    # from a local store.
    #######
  end
  
  def scan
    file = File.join(Rho::RhoApplication::get_model_path('app','BarcodeScan'),'grown_ups.png')
    get_product(Barcode.barcode_recognize(file), @@country_code)
  end
  
  def new
    Camera::take_picture(url_for :action => :camera_callback)
  end
  
  def choose
    Camera::choose_picture(url_for :action => :camera_callback)
  end
  
  def camera_callback
    get_product(Barcode.barcode_recognize(Rho::RhoApplication::get_blob_path(@params['image_uri'])), @@country_code)
    #render_transition :action => :index
  end
  
  def take
    Barcode.take_barcode(url_for(:action => :take_callback), {})
    #Barcode.take_barcode(url_for(:action => :take_callback), {:camera => 'front'})
    #redirect :action => :index
  end

  def take_callback
    status = @params['status']
    barcode = @params['barcode']

    puts 'BarcodeRecognizer::take_callback !'
    puts 'status = '+status.to_s unless status == nil
    puts 'barcode = '+barcode.to_s unless barcode == nil

    if status == 'ok'
      get_product(barcode, @@country_code)
    end
    
    if status == 'cancel'
      Alert.show_popup  ('Barcode taking was canceled !')  
    end
    #redirect :action => :index
  end
  
  def handle_product
    @products = @params['body'].with_indifferent_access[:items]
    unless @products.blank?
      render_transition :action => :product
    end
  end
  
  def search_title
    wanted_title = @params['title']
    movies = get_movies_xbmc
    found_movies = []
    puts "Looking for #{wanted_title}"
    unless movies.blank? && wanted_title.blank?
      movies.each do | movie |
        puts "Looking at #{movie.title}"
        if wanted_title.downcase.include?(movie.title.downcase)
          puts "adding similar movie"
          found_movies << movie
        end
      end
    end
    unless found_movies.blank?
      if found_movies.length == 1
        url = url_for(:controller => :Movie, :action => :show, :id => found_movies[0].object)
        WebView.execute_js("$.mobile.changePage('#{url}', { transition: 'slide'});")
      elsif found_movies.length > 1
        
      else
        
      end
    end
  end
  
end