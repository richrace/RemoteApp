# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

# Module that contains VideoLibrary commands for XBMC JSON RPC API Version 4
module VideoLibrary4
  
  # Requests XBMC to clean the Video Library
  def clean(callback)
    XbmcConnect::VideoLibrary.clean(callback)
  end
    
  # Requests XBMC to scan the Video Library
  def scan(callback)
    XbmcConnect::VideoLibrary.scan(callback)
  end
  
  # Requests XBMC to send the complete list of Movies stored. 
  # Movie information requested is: year, genre, studio, sorttitle, 
  # rating, trailer, imdbnumber, plotoutline, tagline, director, 
  # file, playcount, fanart, thumbnail, plot, title
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
  
  # Gets the more recent Thumbnail from the XBMC Server.
  def get_movie_thumb(callback, movieid)
    params = {
      :movieid => movieid.to_i,
      :properties => [
        "thumbnail"
        ]
    }
    XbmcConnect::VideoLibrary.get_movie_details(callback, params)
  end
  
  # Requests XBMC to send the complete list of TV Shows stored. 
  # TV Show information requested is: title, genre, year, rating, 
  # plot, studio, playcount, episode, imdbnumber, premiered, votes, 
  # lastplayed, fanart, thumbnail, file, originaltitle, sorttitle, episodeguide
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
  
  # Requests XBMC to send the complete list of TV Seasons stored. 
  # TV Season information requested is: season, showtitle, playcount, 
  # episode, fanart, thumbnail, tvshowid
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
  
  # Requests XBMC to send the complete list of TV Seasons stored. 
  # TV Season information requested is: title, plot, rating, firstaired, 
  # playcount, runtime, season, episode, fanart, thumbnail, tvshowid
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