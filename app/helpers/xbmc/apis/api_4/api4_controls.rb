# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'helpers/error_helper'

# Module that contains all the controls for XBMC JSON RPC API Version 4
# Supports all the types of players, Audio, Video and SlideShow.
module Control4
  include ErrorHelper
  
  # Retrieves the current active player. Uses a synchronous method 
  # to get the active player.
  def get_player
    res = XbmcConnect::Player.get_active_players(XbmcConnect::NOCALLB)
    if res['status'] != 'ok'
      error_handle(res)
      return nil
    else
      return res['body'].with_indifferent_access[:result]
    end
  end

  # Plays/Pauses the current media on the XBMC server
  def play_pause(callback)
    cur_player = get_player
    unless cur_player.blank?
      XbmcConnect::Player.play_pause(callback, {:playerid => cur_player[0][:playerid]})
    end
  end

  # Stops the current media on the XBMC server
  def stop(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.stop(callback, {:playerid => cur_player[0][:playerid]})
    end
  end
  
  # Fast Forwards the current media on the XBMC server
  def fast_forward(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.set_speed(callback, {:playerid => cur_player[0][:playerid], :speed => "increment"})
    end
  end
  
  # Rewinds the current media on the XBMC server
  def rewind(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.set_speed(callback, {:playerid => cur_player[0][:playerid], :speed => "decrement"})
    end
  end
  
  # Does a big skip forward on the current media on the XBMC server
  def big_skip_forward(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.seek(callback, {:playerid => cur_player[0][:playerid], :value => "bigforward" })
    end
  end
  
  # Small skip forward on the current media on the XBMC server
  def sm_skip_forward(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.seek(callback, {:playerid => cur_player[0][:playerid], :value => "smallforward" })
    end
  end

  # Big Skip backward the current media on the XBMC server
  def big_skip_back(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.seek(callback, {:playerid => cur_player[0][:playerid], :value => "bigbackward" })
    end
  end

  # Small skip backwards the current media on the XBMC server
  def sm_skip_back(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.seek(callback, {:playerid => cur_player[0][:playerid], :value => "smallbackward" })
    end
  end
  
  # Makes the XBMC server Audio, Video and slideshow skip
  # to the next on playlist, or chapter (video only)
  def skip_next(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.go_next(callback, {:playerid => cur_player[0][:playerid]})
    end
  end

  # Makes the XBMC server Audio, Video and slideshow skip
  # to the previous on playlist, or chapter (video only)
  def skip_prev(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.go_previous(callback, {:playerid => cur_player[0][:playerid]})
    end
  end

end