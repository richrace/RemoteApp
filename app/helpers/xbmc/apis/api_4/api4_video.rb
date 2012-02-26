require 'helpers/xbmc/apis/xbmc_apis'

module VideoLibrary4
  
  def clean(callback)
    XbmcConnect::VideoLibrary.clean(callback)
  end
    
  def scan(callback)
    XbmcConnect::VideoLibrary.scan(callback)
  end
  
  def get_movies(callback)
    params = {
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
    XbmcConnect::VideoLibrary.get_movies(callback, params)
  end
  
  def get_movie_thumb(callback, movieid)
    params = {
      :movieid => movieid.to_i,
      :properties => [
        "thumbnail"
        ]
    }
    XbmcConnect::VideoLibrary.get_movie_details(callback, params)
  end
  
  def get_tv_shows(callback)
    params = {
      :properties => [
        "title", 
        "genre", 
        "year", 
        "rating", 
        "plot", 
        "studio", 
        "playcount", 
        "episode", 
        "imdbnumber", 
        "premiered", 
        "votes", 
        "lastplayed", 
        "fanart", 
        "thumbnail", 
        "file", 
        "originaltitle", 
        "sorttitle", 
        "episodeguide"
      ]
    }
    XbmcConnect::VideoLibrary.get_tv_shows(callback, params)
  end
  
  def get_seasons(callback, tvshowid)
    params = {
      :tvshowid => tvshowid.to_i,
      :properties => [
        "season", 
        "showtitle", 
        "playcount", 
        "episode", 
        "fanart", 
        "thumbnail", 
        "tvshowid"
      ]
    }
    XbmcConnect::VideoLibrary.get_seasons(callback, params)
  end
  
  def get_episodes(callback, tvshowid, seasonid)
    params = {
      :tvshowid => tvshowid.to_i,
      :season => seasonid.to_i,
      :properties => [
        "title", 
        "plot", 
        "rating", 
        "firstaired", 
        "playcount", 
        "runtime", 
        "season", 
        "episode", 
        "fanart", 
        "thumbnail", 
        "tvshowid"
      ]
    }
    XbmcConnect::VideoLibrary.get_episodes(callback, params)
  end
end