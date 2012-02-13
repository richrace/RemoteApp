require 'helpers/error_helper'

module Control4
  include ErrorHelper
    
  def get_player
    res = XbmcConnect::Player.get_active_players(XbmcConnect::NOCALLB)
    if res['status'] != 'ok'
      error_handle(res)
      return nil
    else
      return res['body'].with_indifferent_access[:result]
    end
  end

  def play_pause(callback)
    cur_player = get_player
    unless cur_player.blank?
      XbmcConnect::Player.play_pause(callback, {:playerid => cur_player[0][:playerid]})
    end
  end
  
  def stop(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.stop(callback, {:playerid => cur_player[0][:playerid]})
    end
  end
  
  def fast_forward(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.set_speed(callback, {:playerid => cur_player[0][:playerid], :speed => "increment"})
    end
  end
  
  def rewind(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.set_speed(callback, {:playerid => cur_player[0][:playerid], :speed => "decrement"})
    end
  end
  
  def big_skip_forward(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.seek(callback, {:playerid => cur_player[0][:playerid], :value => "bigforward" })
    end
  end
  
  def sm_skip_forward(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.seek(callback, {:playerid => cur_player[0][:playerid], :value => "smallforward" })
    end
  end

  def big_skip_back(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.seek(callback, {:playerid => cur_player[0][:playerid], :value => "bigbackward" })
    end
  end

  def sm_skip_back(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.seek(callback, {:playerid => cur_player[0][:playerid], :value => "smallbackward" })
    end
  end
  
  def skip_next(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.go_next(callback, {:playerid => cur_player[0][:playerid]})
    end
  end

  def skip_prev(callback)
    cur_player = get_player
    unless cur_player.blank? 
      XbmcConnect::Player.go_previous(callback, {:playerid => cur_player[0][:playerid]})
    end
  end
  
  def play_movie(callback, movieid)
    # Playlist ID is 1 as it used for Video.
    cplay_param = {:playlistid => 1}
    cplay_res = XbmcConnect::Playlist.clear(XbmcConnect::NOCALLB, cplay_param)
    aplay_param = {:playlistid => 1, :item => {:movieid => movieid.to_i}}
    aplay_res = XbmcConnect::Playlist.add(XbmcConnect::NOCALLB, aplay_param)
    open_param = {:item => {:playlistid => 1}}
    open_res = XbmcConnect::Player.open(XbmcConnect::NOCALLB, open_param)
  end
end