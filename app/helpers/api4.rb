
class ApiV4
  
  VERSION = 4
  
  class << self
    
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
      cur_player = get_player[0][:playerid]

      Controls.send_command {XbmcConnect::Player.play_pause(callback, {:playerid => cur_player})}
    end
  
  end
end