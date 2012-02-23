module GeoHelper
  
  def get_geo
    # Starts GeoLocation.
    GeoLocation.accuracy
    # check if we know our position   
    if !GeoLocation.known_position?
      # wait till GPS receiver acquire position
      GeoLocation.set_notification(url_for(:controller => :Geo, :action => :geo_callback), "", 30)
    else
      long = "lng=#{GeoLocation.longitude}"
      lat = "lat=#{GeoLocation.latitude}"
      GeoLocation.turnoff
      set_country_code(long,lat)
    end
  end
  
  def get_country_code
    # navigate to `show_location` page if GPS receiver acquire position  
    if @params['known_position'].to_i != 0 && @params['status'] =='ok'  
      GeoLocation.turnoff
      long = "lng=#{@params['longitude']}"
      lat = "lat=#{@params['latitude']}"
      set_country_code(long,lat)
    end   
    # show error if timeout expired and GPS receiver didn't acquire position
    if @params['available'].to_i == 0 || @params['status'] !='ok'
      GeoLocation.turnoff
      @@country_code = System.get_property('country')
    end
    # do nothing, still wait for location
  end
  
  def set_country_code(long, lat)
    url = "http://api.geonames.org/countryCode?type=json&#{lat}&#{long}&username=xbmcremote"
    res = Rho::AsyncHttp.get(:url => url)
    @@country_code = res['body']['countryCode']
  end
  
end