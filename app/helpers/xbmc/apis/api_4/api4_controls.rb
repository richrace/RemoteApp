require 'helpers/error_helper'

module Control4
    
  def get_player
    res = XbmcConnect::Player.get_active_players(XbmcConnect::NOCALLB)
    if res['status'] != 'ok'
      ErrorHelper.error_handle(res)
      return nil
    else
      return res['body'].with_indifferent_access[:result]
    end
  end

  def play_pause(callback)
    cur_player = get_player
    unless cur_player.blank? 
      Controls.send_command {XbmcConnect::Player.play_pause(callback, {:playerid => cur_player[0][:playerid]})}
    end
  end
  
  def stop(callback)
    cur_player = get_player
    unless cur_player.blank? 
      Controls.send_command {XbmcConnect::Player.stop(callback, {:playerid => cur_player[0][:playerid]})}
    end
  end
  
  def fast_forward(callback)
    cur_player = get_player
    unless cur_player.blank? 
      Controls.send_command {XbmcConnect::Player.set_speed(callback, {:playerid => cur_player[0][:playerid], :speed => "increment"})}
    end
  end
  
  def rewind(callback)
    cur_player = get_player
    unless cur_player.blank? 
      Controls.send_command {XbmcConnect::Player.set_speed(callback, {:playerid => cur_player[0][:playerid], :speed => "decrement"})}
    end
  end
  
  def big_skip_forward(callback)
    cur_player = get_player
    unless cur_player.blank? 
      Controls.send_command {XbmcConnect::Player.seek(callback, {:playerid => cur_player[0][:playerid], :value => "bigforward" })}
    end
  end
  
  def sm_skip_forward(callback)
    cur_player = get_player
    unless cur_player.blank? 
      Controls.send_command {XbmcConnect::Player.seek(callback, {:playerid => cur_player[0][:playerid], :value => "smallforward" })}
    end
  end

  def big_skip_back(callback)
    cur_player = get_player
    unless cur_player.blank? 
      Controls.send_command {XbmcConnect::Player.seek(callback, {:playerid => cur_player[0][:playerid], :value => "bigbackward" })}
    end
  end

  def sm_skip_back(callback)
    cur_player = get_player
    unless cur_player.blank? 
      Controls.send_command {XbmcConnect::Player.seek(callback, {:playerid => cur_player[0][:playerid], :value => "smallbackward" })}
    end
  end
  
  def skip_next(callback)
    cur_player = get_player
    unless cur_player.blank? 
      Controls.send_command {XbmcConnect::Player.go_next(callback, {:playerid => cur_player[0][:playerid]})}
    end
  end

  def skip_prev(callback)
    cur_player = get_player
    unless cur_player.blank? 
      Controls.send_command {XbmcConnect::Player.go_previous(callback, {:playerid => cur_player[0][:playerid]})}
    end
  end
  
end