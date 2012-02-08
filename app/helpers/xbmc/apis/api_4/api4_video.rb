require 'helpers/xbmc/apis/xbmc_apis'

module VideoLibrary4
  
  def clean(callback)
    XbmcConnect::VideoLibrary.clean(callback)
  end
    
  def scan(callback)
    XbmcConnect::VideoLibrary.scan(callback)
  end
  
  def get_movies(callback)
    XbmcConnect::VideoLibrary.get_movies(callback)
  end
  
  def get_movie_detail(callback, movieid)
    params = {
      :movieid => Integer(movieid),
      :properties => [
        "year",
        "genre",
        "studio",
        "sorttitle",
        "rating",
        "trailer",
        "imdbnumber",
        "plotoutline",
        "tagline",
        "director",
        "file",
        "playcount",
        "fanart",
        "thumbnail",
        "plot",
        "title"
        ]
    }
    XbmcConnect::VideoLibrary.get_movie_details(callback, params)
  end
  
end