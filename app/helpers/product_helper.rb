module ProductHelper
  
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
  
end