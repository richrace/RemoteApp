require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/geo_helper'
require 'helpers/product_helper'
require 'helpers/movie_helper'
require 'helpers/error_helper'

class BarcodeScanController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include GeoHelper
  include ProductHelper
  include MovieHelper
  include ErrorHelper
  
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
  
  def new
    Camera::take_picture(url_for :action => :camera_callback)
  end
  
  def choose
    Camera::choose_picture(url_for :action => :camera_callback)
  end
  
  def camera_callback
    WebView.execute_js("showLoading('Scanning Barcode');");
    barcode = Barcode.barcode_recognize(Rho::RhoApplication::get_blob_path(@params['image_uri']))
    if barcode.blank?
      # Need the \ characters to make sure the error is displayed properlly by the JavaScript.
      WebView.execute_js("showToastError('Couldn\\\'t Scan the Barcode');")
      WebView.execute_js("hideLoading();")
    else
      get_product(barcode, @@country_code)
    end
  end
  
  def take
    Barcode.take_barcode(url_for(:action => :take_callback), {})
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
  end
  
  def handle_product
    WebView.execute_js("hideLoading();");
    if @params['status'] == 'ok'
      @google_products = @params['body'].with_indifferent_access[:items]
      unless @google_products.blank?
        render_transition :action => :product_list
      else 
        url = url_for(:controller => :Product, :action => :new, :query => {:known => false})
        WebView.execute_js("$.mobile.changePage('#{url}', { transition: 'slide'});")
      end
    else
      error_handle(@params)
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    end
  end
  
  def search_title
    wanted_title = @params['title']
    movies = get_movies_xbmc
    found_movies = search_by_title(wanted_title)
    unless found_movies.blank?
      if found_movies.length == 1
        redirect(:controller => :Movie, :action => :show, :id => found_movies[0].object)
      elsif found_movies.length > 1
        redirect(:controller => :Movie, :action => :found, :query => {:movies => :found_movies})
      end
    else
      redirect(:controller => :Product, :action => :new, :query => {:known => true, :title => wanted_title})
    end
  end
  
end