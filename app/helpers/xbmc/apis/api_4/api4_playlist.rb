module Playlist4

	def get_video_items(callback)
    params = {:playlistid => 1}
    XbmcConnect::Playlist.get_items(callback, params)
  end

  def clear_video(callback=XbmcConnect::NOCALLB)
    params = {:playlistid => 1}
    XbmcConnect::Playlist.clear(callback, params)
  end
  
  def play_video(callback=XbmcConnect::NOCALLB)
    play_video_position(0, callback)
  end

  def play_video_position(position, callback=XbmcConnect::NOCALLB) 
    params = {:item => {:playlistid => 1, :position => position.to_i}}
    XbmcConnect::Player.open(callback, params)
  end

  def add_episode(episodeid, callback=XbmcConnect::NOCALLB)
    params = {:playlistid => 1, :item => {:episodeid => episodeid.to_i}}
    XbmcConnect::Playlist.add(callback, params)
  end

  def add_movie(movieid, callback=XbmcConnect::NOCALLB)
    params = {:playlistid => 1, :item => {:movieid => movieid.to_i}}
    XbmcConnect::Playlist.add(callback, params)
  end
  
  def play_movie(movieid, callback=XbmcConnect::NOCALLB)
    clear_res = clear_video
    add_res = add_movie(movieid)
    play_video(callback)
  end
  
  def play_episode(episodeid, callback=XbmcConnect::NOCALLB)
    clear_res = clear_video
    add_res = add_episode(episodeid)
    play_video(callback)
  end

  def remove_video_position(position, callback=XbmcConnect::NOCALLB) 
    params = {:playlistid => 1, :position => position.to_i}
    XbmcConnect::Playlist.remove(callback, params)
  end
end