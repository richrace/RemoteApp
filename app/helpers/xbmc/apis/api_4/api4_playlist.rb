# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

# Module that contains Playlist commands for XBMC JSON RPC API Version 4
module Playlist4

  # Requests the list of Items that are in the current active video playlist
	def get_video_items(callback)
    params = {:playlistid => 1}
    XbmcConnect::Playlist.get_items(callback, params)
  end

  # Clears the Video Playlist
  def clear_video(callback=XbmcConnect::NOCALLB)
    params = {:playlistid => 1}
    XbmcConnect::Playlist.clear(callback, params)
  end
  
  # Plays the video playlist at the beginning.
  def play_video(callback=XbmcConnect::NOCALLB)
    play_video_position(0, callback)
  end

  # Plays the Video playlist at the given position.
  def play_video_position(position, callback=XbmcConnect::NOCALLB) 
    params = {:item => {:playlistid => 1, :position => position.to_i}}
    XbmcConnect::Player.open(callback, params)
  end

  # Adds an episode to the video playlist.
  def add_episode(episodeid, callback=XbmcConnect::NOCALLB)
    params = {:playlistid => 1, :item => {:episodeid => episodeid.to_i}}
    XbmcConnect::Playlist.add(callback, params)
  end

  # Adds a Movie to the video playlist
  def add_movie(movieid, callback=XbmcConnect::NOCALLB)
    params = {:playlistid => 1, :item => {:movieid => movieid.to_i}}
    XbmcConnect::Playlist.add(callback, params)
  end
  
  # Plays a given movie. Clears the video playlist first, then adds a the give Movie.
  # Uses a synchronous connection for clearing and adding the movie.
  def play_movie(movieid, callback=XbmcConnect::NOCALLB)
    clear_res = clear_video
    add_res = add_movie(movieid)
    play_video(callback)
  end
  
  # Plays a given Episode. Clears the video playlist first, then adds a the give Episode.
  # Uses a synchronous connection for clearing and adding the Episode.
  def play_episode(episodeid, callback=XbmcConnect::NOCALLB)
    clear_res = clear_video
    add_res = add_episode(episodeid)
    play_video(callback)
  end

  # Removes an episode/movie from the video playlist at the given position.
  def remove_video_position(position, callback=XbmcConnect::NOCALLB) 
    params = {:playlistid => 1, :position => position.to_i}
    XbmcConnect::Playlist.remove(callback, params)
  end
end