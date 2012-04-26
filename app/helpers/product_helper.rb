# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

# Gets the Products associated with a Barcode using the Google Shopping API.
module ProductHelper
  
  # Requires the Barcode number and the Country Code.
  # Gets only 5 results from the Google Shopping API to improve times to download.
  # When making project Open Source, require to update the Google API Key.
  def get_product(code, country)
    unless code.blank?
      @barcode = code
      @country = country
      
      google_api_key = "AIzaSyD6zfGyGIia-TF9cW4wf85xnz4mvM6RSto"
      
      Rho::AsyncHttp.get(
        :url => "https://www.googleapis.com/shopping/search/v1/public/products?country=#{@country}&q=#{@barcode}&maxResults=5&key=#{google_api_key}",
        :callback => url_for(:action => :handle_product)
      )
    end
  end

  # Filters the Products (AKA Buy Later List) to those associated with the 
  # current XBMC Configuration.
  def filter_products_xbmc
    xbmc = XbmcConfigHelper.current_config
    unless xbmc.blank?
      Product.find(:all, :conditions => {:xbmc_id => xbmc.object})
    else
      return []
    end
  end
  
end