# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'
require 'helpers/geo_helper'
require 'helpers/product_helper'
require 'helpers/movie_helper'
require 'helpers/error_helper'

# Controller for the Barcode scanning facility,
class BarcodeScanController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  include GeoHelper
  include ProductHelper
  include MovieHelper
  include ErrorHelper
  
  # Sets the default country code to be US.
  # GET /BarcodeScan
  def index
    @@country_code = "US"
    render
  end
  
  # Loads the current GeoLocation.
  def load_geo
    get_geo
  end
  
  # Takes a picture if the user can't/doesn't want to take a live scan.
  # Uses the Rhodes API.
  def new
    Camera::take_picture(url_for :action => :camera_callback)
  end
  
  # Allows the user to select a picture from their Phone's library.
  # Uses the Rhodes API.
  def choose
    Camera::choose_picture(url_for :action => :camera_callback)
  end
  
  # Callback from choosing a picture. Starts the barcode scanning process using the Rhodes API.
  # Informs the user if the barcode cannot be scanned. If it can, it uses the barcode to the load the 
  # related product via the Google Shopping API.
  def camera_callback
    barcode = Barcode.barcode_recognize(Rho::RhoApplication::get_blob_path(@params['image_uri']))
    if barcode.blank?
      # Need the \ characters to make sure the error is displayed properlly by the JavaScript.
      WebView.execute_js("showToastError('Couldn\\\'t Scan the Barcode');")
    else
      get_product(barcode, @@country_code)
    end
  end
  
  # live scan of a barcode
  def take
    Barcode.take_barcode(url_for(:action => :take_callback), {})
  end

  # Callback for live scan of barcode, informs the user if the barcode couldn't be scanned.
  # If it could will go an load the products from the Google Shopping API.
  def take_callback
    status = @params['status']
    barcode = @params['barcode']
    
    if status == 'cancel'
      Alert.show_popup  ('Barcode taking was canceled !')  
    elsif barcode.blank?
      # Need the \ characters to make sure the error is displayed properlly by the JavaScript.
      WebView.execute_js("showToastError('Couldn\\\'t Scan the Barcode');")
    else
      get_product(barcode, @@country_code)
    end
  end
  
  # Displays the products that were found via the Google Shopping API.
  # Will inform the user if there was a connection problem.
  # If there are no products found will send the user to enter manually the 
  # product.
  def handle_product
    if @params['status'] == 'ok'
      @google_products = @params['body'].with_indifferent_access[:items]
      unless @google_products.blank?
        render_transition(:action => :product_list)
      else 
        WebView.execute_js("showToastError('No Matches');")
        url = url_for(:controller => :Product, :action => :new, :query => {:known => false})
        # Needed to make sure the page changes. Uses JQuery Mobile to change page.
        WebView.execute_js("$.mobile.changePage('#{url}', { transition: 'slide'});")
      end
    else
      error_handle(@params)
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    end
  end
  
  # Checks the given title for possible matches within the Movies database. 
  # If there is a match it will redirect the user to the correct Movie information page.
  # If there is more than one possible match it will take the user to a list of possible matches
  # If there is no match, it will take the user to enter a new entry in the Buy Later List.
  def search_title
    wanted_title = @params['title']
    found_movies = search_by_title(wanted_title)
    unless found_movies.blank?
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
    else
      redirect(:controller => :Product, :action => :new, :query => {:known => true, :title => wanted_title})
    end
  end
  
end